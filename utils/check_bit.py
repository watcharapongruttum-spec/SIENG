
import os
from PIL import Image
import cv2
import numpy as np
from scipy.signal import convolve2d

def check_bit_message(message,previous_text_length,num):
    current_length = len(''.join(format(byte, '08b') for byte in message.encode('utf-8')))

    # กรณีที่ข้อความเป็นช่องว่างหรือข้อความทั้งหมดถูกลบ
    if current_length == 0 and previous_text_length > 0:
        num += previous_text_length  # เพิ่ม num เมื่อข้อความถูกลบทั้งหมด
    # กรณีข้อความถูกเพิ่ม
    elif current_length > previous_text_length:
        num -= (current_length - previous_text_length)  # ลด num ตามจำนวนข้อความที่เพิ่ม
    # กรณีข้อความถูกลบ
    elif current_length < previous_text_length:
        num += (previous_text_length - current_length)  # เพิ่ม num ตามจำนวนข้อความที่ถูกลบ
        

    if num < 0:
        setText=f"bit เกิน {abs(num)}"
        setStyleSheet ="color: red; font-weight: bold; font-size: 34px; background-color: transparent;"
    else:
        # อัปเดตข้อความแสดงจำนวนตัวอักษรที่ใส่ได้
        setText=f"bit เหลือ {abs(num)}"
        setStyleSheet ="color: green; font-weight: bold; font-size: 34px; background-color: transparent;"

    return num,setText,setStyleSheet,current_length


def check_bit_palette2(image_path):
    temp_png_path = "temp_image.png"
    img = Image.open(image_path)
    img.convert("RGB").save(temp_png_path, format="PNG")

    try:
        img_p = Image.open(temp_png_path).convert("P")
        palette = img_p.getpalette()
        print(f"check_bit_palette ==> Palette size: {len(palette)}, Colors: {len(palette)//3}")
    finally:
        if os.path.exists(temp_png_path):
            os.remove(temp_png_path)
    return len(palette) - 16


def check_bit_palette(image_path, show_lsb=False):
    img = Image.open(image_path)
    print(f"Image mode: {img.mode}")
    if img.mode != "P":
        return 0
    palette = img.getpalette()
    num_colors = len(palette) // 3
    print(f"Palette size: {len(palette)}, Colors: {num_colors}")

    if show_lsb:
        lsb_list = [p & 1 for p in palette[:64]]
    return len(palette)-16


def check_bit_lsb(image_path):
    img = Image.open(image_path).convert('RGB')
    arr = np.array(img)
    height, width, channels = arr.shape
    max_bits = height * width * channels
    return max_bits - 16






def check_bit_edge_detection(image_path):
    """ตรวจสอบจำนวนพิกเซล edge ที่ใช้ซ่อนข้อความ (รองรับ PNG, BMP, TIFF)"""
    ext = image_path.split('.')[-1].lower()
    if ext not in ['png', 'bmp', 'tiff', 'tif']:
        return 0

    # โหลดภาพด้วย PIL
    img = Image.open(image_path)
    
    # แยก alpha ถ้ามี
    if img.mode == 'RGBA':
        alpha = img.split()[-1]
        img = img.convert('RGB')
    else:
        alpha = None

    # แปลงเป็น NumPy array
    img_array = np.array(img)
    if img_array.ndim == 2:  # ถ้าเป็น grayscale
        img_array = np.stack([img_array]*3, axis=-1)
    
    # แปลงเป็น grayscale สำหรับ edge detection
    gray_img = img.convert('L')
    gray_array = np.array(gray_img)

    # Sobel edge detection
    sobel_x = np.array([[-1,0,1],[-2,0,2],[-1,0,1]])
    sobel_y = np.array([[-1,-2,-1],[0,0,0],[1,2,1]])
    grad_x = np.abs(convolve2d(gray_array, sobel_x, mode='same'))
    grad_y = np.abs(convolve2d(gray_array, sobel_y, mode='same'))
    edges = np.sqrt(grad_x**2 + grad_y**2)
    
    threshold = 30
    edges_binary = edges > threshold
    edge_pixels = np.count_nonzero(edges_binary)

    # ลบ margin เล็กน้อยเพื่อความปลอดภัย
    usable_edge_pixels = max(edge_pixels - 64, 0)

    # ปรับสัดส่วนตามนามสกุลไฟล์
    if ext in ['tiff', 'tif']:
        usable_edge_pixels = int(usable_edge_pixels * 0.08)
    elif ext == 'png':
        usable_edge_pixels = int(usable_edge_pixels * 0.03)
    elif ext == 'bmp':
        usable_edge_pixels = int(usable_edge_pixels * 0.0022)

    print(f"🖼️ Shape ของภาพ: {img_array.shape}")
    print(f"🔍 จำนวน edge pixels ที่ใช้ได้ (ปรับสัดส่วนตามไฟล์): {usable_edge_pixels}")
    
    return usable_edge_pixels






def check_bit_alpha_channel(image_path):
    img = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)
    if img is None or img.shape[2] != 4:
        return 0
    max_bits = img.shape[0] * img.shape[1]
    print(f"🔢 จำนวนบิตสูงสุดที่สามารถฝังได้: {max_bits}")
    return max_bits-8




def check_bit_masking_filtering(image_path):
    # ตรวจสอบนามสกุล
    ext = image_path.split('.')[-1].lower()
    if ext not in ['bmp', 'png', 'tiff']:
        return 0

    # โหลดภาพ
    img = cv2.imread(image_path, cv2.IMREAD_COLOR)
    if img is None:
        return 0

    # สร้าง edge mask จาก grayscale
    gray = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    edges = cv2.Canny(gray, 100, 200)
    edge_pixels = np.count_nonzero(edges)

    # ลบ 32 บิตสำหรับ header
    safe_bits = edge_pixels - 32
    if safe_bits <= 0:
        return 0

    # ปรับตามชนิดของภาพ
    if ext == 'png':
        safe_bits = int(safe_bits * 0.2)   # 20%
    elif ext == 'bmp':
        safe_bits = int(safe_bits * 0.8)   # 80%
    elif ext == 'tiff':
        safe_bits = int(safe_bits * 0.6)   # 60%

    return safe_bits





















