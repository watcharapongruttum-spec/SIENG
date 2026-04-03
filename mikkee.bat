@echo off
setlocal
set PYTHONUTF8=1
cd /d "%~dp0"

REM ============================
REM Create Beautiful GUI with HTA
REM ============================
set GUI_FILE=%temp%\install_gui.hta
(
echo ^<html^>
echo ^<head^>
echo ^<title^>Python Dependency Installer^</title^>
echo ^<HTA:APPLICATION
echo     ID="InstallApp"
echo     APPLICATIONNAME="Python Installer"
echo     BORDER="none"
echo     BORDERSTYLE="normal"
echo     CAPTION="yes"
echo     MAXIMIZEBUTTON="no"
echo     MINIMIZEBUTTON="yes"
echo     SHOWINTASKBAR="yes"
echo     SINGLEINSTANCE="yes"
echo     SYSMENU="yes"
echo     WINDOWSTATE="normal"
echo     SCROLL="no"
echo /^>
echo ^<style^>
echo * { margin: 0; padding: 0; box-sizing: border-box; }
echo body {
echo     font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
echo     background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%^);
echo     display: flex;
echo     justify-content: center;
echo     align-items: center;
echo     height: 100vh;
echo     overflow: hidden;
echo }
echo .container {
echo     background: rgba(255, 255, 255, 0.95^);
echo     border-radius: 15px;
echo     padding: 25px;
echo     box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3^);
echo     text-align: center;
echo     min-width: 320px;
echo     max-width: 380px;
echo     animation: slideIn 0.5s ease-out;
echo }
echo @keyframes slideIn {
echo     from { transform: translateY(-50px^); opacity: 0; }
echo     to { transform: translateY(0^); opacity: 1; }
echo }
echo h1 {
echo     color: #667eea;
echo     font-size: 20px;
echo     margin-bottom: 8px;
echo     font-weight: 600;
echo }
echo .status {
echo     color: #666;
echo     font-size: 13px;
echo     margin: 12px 0;
echo     min-height: 20px;
echo }
echo .progress-container {
echo     width: 100%%;
echo     height: 6px;
echo     background: #e0e0e0;
echo     border-radius: 8px;
echo     overflow: hidden;
echo     margin: 15px 0;
echo }
echo .progress-bar {
echo     height: 100%%;
echo     background: linear-gradient(90deg, #667eea 0%%, #764ba2 100%%^);
echo     border-radius: 8px;
echo     animation: progress 2s ease-in-out infinite;
echo     width: 0%%;
echo }
echo @keyframes progress {
echo     0%% { width: 0%%; }
echo     50%% { width: 70%%; }
echo     100%% { width: 100%%; }
echo }
echo .spinner {
echo     border: 3px solid #f3f3f3;
echo     border-top: 3px solid #667eea;
echo     border-radius: 50%%;
echo     width: 30px;
echo     height: 30px;
echo     animation: spin 1s linear infinite;
echo     margin: 15px auto;
echo }
echo @keyframes spin {
echo     0%% { transform: rotate(0deg^); }
echo     100%% { transform: rotate(360deg^); }
echo }
echo .details {
echo     background: #f8f9fa;
echo     border-radius: 8px;
echo     padding: 10px;
echo     margin-top: 15px;
echo     font-size: 11px;
echo     color: #555;
echo     text-align: left;
echo     max-height: 100px;
echo     overflow-y: auto;
echo }
echo .success {
echo     color: #28a745;
echo     font-weight: 600;
echo }
echo .error {
echo     color: #dc3545;
echo     font-weight: 600;
echo }
echo ^</style^>
echo ^</head^>
echo ^<body^>
echo ^<div class="container"^>
echo     ^<h1^>Python Installer^</h1^>
echo     ^<div class="status" id="status"^>Preparing installation...^</div^>
echo     ^<div class="progress-container"^>
echo         ^<div class="progress-bar" id="progressBar"^>^</div^>
echo     ^</div^>
echo     ^<div class="spinner" id="spinner"^>^</div^>
echo     ^<div class="details" id="details"^>
echo         ^<div^>Checking system...^</div^>
echo     ^</div^>
echo ^</div^>
echo ^<script^>
echo var statusEl = document.getElementById('status'^);
echo var detailsEl = document.getElementById('details'^);
echo var steps = [
echo     'Checking Python...',
echo     'Checking pip...',
echo     'Reading requirements.txt...',
echo     'Installing dependencies...',
echo     'Installation complete!'
echo ];
echo var currentStep = 0;
echo function updateStatus(^) {
echo     if (currentStep ^< steps.length^) {
echo         statusEl.innerText = steps[currentStep];
echo         var detail = document.createElement('div'^);
echo         detail.innerText = '- ' + steps[currentStep];
echo         detail.style.marginTop = '5px';
echo         detailsEl.appendChild(detail^);
echo         detailsEl.scrollTop = detailsEl.scrollHeight;
echo         currentStep++;
echo         setTimeout(updateStatus, 1500^);
echo     }
echo }
echo setTimeout(updateStatus, 500^);
echo ^</script^>
echo ^</body^>
echo ^</html^>
) > "%GUI_FILE%"

REM Run GUI in background
start "" mshta "%GUI_FILE%"

REM Wait for GUI to display
timeout /t 2 /nobreak >nul

echo ===============================
echo Checking Python dependencies...
echo ===============================

REM Check if requirements.txt exists
if not exist requirements.txt (
    echo requirements.txt not found
    timeout /t 3 /nobreak >nul
    taskkill /IM mshta.exe /F >nul 2>&1
    pause
    exit /b
)

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo Python not found or PATH not configured
    timeout /t 3 /nobreak >nul
    taskkill /IM mshta.exe /F >nul 2>&1
    pause
    exit /b
)

REM Check if pip is available
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo pip not found or Python installation incomplete
    timeout /t 3 /nobreak >nul
    taskkill /IM mshta.exe /F >nul 2>&1
    pause
    exit /b
)

REM Create temp file to store current libraries
python -m pip freeze > "%temp%\installed_libs.txt"

REM Check if requirements.txt matches installed libraries
fc /L /N requirements.txt "%temp%\installed_libs.txt" >nul
if errorlevel 1 (
    echo Some libraries are missing or version mismatch
    echo Installing from requirements.txt...
    python -m pip install --no-deps --no-index -r requirements.txt 2>nul
    python -m pip install -r requirements.txt
) else (
    echo All libraries match requirements.txt
)

REM Wait for GUI to finish displaying
timeout /t 3 /nobreak >nul

REM ============================
REM Close GUI
REM ============================
taskkill /FI "WINDOWTITLE eq Python Installer" /F >nul 2>&1

echo ===============================
echo Running main.py...
echo ===============================
python main.py

echo.
echo Task completed
pause
endlocal
