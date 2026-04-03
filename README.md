🛡️ SIENG - Steganography & Encryption Tool
📌 Overview

SIENG เป็นโปรแกรมสำหรับซ่อนข้อมูล (Steganography) และเข้ารหัส (Encryption) ไฟล์หลายประเภท เช่น รูปภาพ เสียง วิดีโอ และเอกสาร โดยออกแบบมาให้ใช้งานง่ายผ่าน GUI และรองรับการทำงานแบบหลายโหมดในโปรแกรมเดียว

โปรเจคนี้ถูกพัฒนาเพื่อศึกษาและทดลองด้าน:

Data Hiding
Cryptography
File Processing
Desktop Application Development (Python)
🚀 Features
🔐 Encryption
เข้ารหัส / ถอดรหัสข้อมูล
รองรับ RSA / PGP Key
ใช้งานกับไฟล์หลากหลายประเภท
🖼️ Image Steganography
ซ่อนข้อความหรือไฟล์ในภาพ
รองรับหลายฟอร์แมต เช่น PNG, BMP, JPG
🔊 Audio Steganography
ฝังข้อมูลลงในไฟล์เสียง (WAV / FLAC)
ดึงข้อมูลกลับออกมาได้
🎥 Video Steganography
ซ่อนข้อมูลในไฟล์วิดีโอ
รองรับ MP4 / AVI / MKV
📁 File Management
ตรวจสอบข้อมูลไฟล์ (metadata)
แสดงรายละเอียดไฟล์
🔄 Integrated Mode
รวมหลายขั้นตอน เช่น
Encrypt → Hide → Extract → Decrypt
ใช้งานแบบ workflow ครบจบในที่เดียว
🏗️ Project Structure
src/
├── main.py                # Entry point
├── tabs/                  # UI Tabs
│   ├── image_tab.py
│   ├── audio_tab.py
│   ├── video_tab.py
│   ├── encryption_tab.py
│   └── ...
├── utils/                 # Core logic
│   ├── steganography.py
│   ├── encryption.py
│   ├── audio_fun.py
│   └── integrated_mode_fun.py
├── photoexample/          # ตัวอย่างรูปภาพ
├── audioexample/          # ตัวอย่างเสียง
├── vdio/                  # ตัวอย่างวิดีโอ
└── requirements.txt
⚙️ Installation
1. Clone Repository
git clone https://github.com/watcharapongruttum-spec/SIENG.git
cd SIENG
2. Install Dependencies
pip install -r requirements.txt
3. Run Program
python main.py
🖥️ Build Executable (Optional)

ใช้ PyInstaller:

pyinstaller main.spec
📸 Example Use Cases
ซ่อนข้อความลับในรูปภาพ
ฝังไฟล์ในเสียงหรือวิดีโอ
เข้ารหัสเอกสารก่อนส่ง
ใช้ศึกษา Cybersecurity / Digital Forensics
🧠 Technologies Used
Python
PyQt / GUI Framework
Cryptography (RSA / PGP)
Steganography Techniques
File Processing
⚠️ Notes
ไฟล์ขนาดใหญ่ (mp3, mp4, exe) ถูก ignore ใน .gitignore
key และ sensitive files ถูกลบออกจาก repo เพื่อความปลอดภัย
เหมาะสำหรับการศึกษา ไม่ควรใช้กับข้อมูลสำคัญระดับ production
👨‍💻 Author

Watcharapong Ruttum

Junior Developer (New Graduate)
สนใจด้าน Security / Backend / System

GitHub:
👉 https://github.com/watcharapongruttum-spec
