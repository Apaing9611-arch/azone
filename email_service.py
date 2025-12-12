"""
Email Service for sending verification codes
"""

import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
import random
import string

# Email configuration - can be set via environment variables
SMTP_SERVER = os.getenv('SMTP_SERVER', 'smtp.gmail.com')
SMTP_PORT = int(os.getenv('SMTP_PORT', '587'))
SMTP_USERNAME = os.getenv('SMTP_USERNAME', '')
SMTP_PASSWORD = os.getenv('SMTP_PASSWORD', '')
FROM_EMAIL = os.getenv('FROM_EMAIL', SMTP_USERNAME)
FROM_NAME = os.getenv('FROM_NAME', 'AZone Bot Builder')

def generate_verification_code(length=6):
    """Generate a random verification code"""
    return ''.join(random.choices(string.digits, k=length))

def send_verification_email(to_email, verification_code, username=None):
    """
    Send verification code email
    
    Args:
        to_email: Recipient email address
        verification_code: The verification code to send
        username: Optional username for personalization
    
    Returns:
        dict: {'success': bool, 'error': str or None}
    """
    if not SMTP_USERNAME or not SMTP_PASSWORD:
        # In development mode, print code to console
        print(f"\n{'='*60}")
        print(f"📧 EMAIL VERIFICATION CODE (Development Mode)")
        print(f"{'='*60}")
        print(f"To: {to_email}")
        if username:
            print(f"Username: {username}")
        print(f"Verification Code: {verification_code}")
        print(f"{'='*60}\n")
        return {'success': True, 'error': None}
    
    try:
        # Create message
        msg = MIMEMultipart('alternative')
        msg['Subject'] = 'AZone - Email Verification Code'
        msg['From'] = f"{FROM_NAME} <{FROM_EMAIL}>"
        msg['To'] = to_email
        
        # Create HTML email body
        html_body = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <style>
                body {{
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    line-height: 1.6;
                    color: #333;
                    max-width: 600px;
                    margin: 0 auto;
                    padding: 20px;
                }}
                .container {{
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 10px;
                    padding: 30px;
                    color: white;
                }}
                .code-box {{
                    background: rgba(255, 255, 255, 0.2);
                    border: 2px dashed white;
                    border-radius: 8px;
                    padding: 20px;
                    text-align: center;
                    margin: 20px 0;
                }}
                .code {{
                    font-size: 32px;
                    font-weight: bold;
                    letter-spacing: 5px;
                    color: white;
                    font-family: 'Courier New', monospace;
                }}
                .footer {{
                    margin-top: 20px;
                    font-size: 12px;
                    opacity: 0.8;
                }}
            </style>
        </head>
        <body>
            <div class="container">
                <h2>Email Verification Code</h2>
                <p>Hello{' ' + username if username else ''},</p>
                <p>Thank you for registering with AZone Bot Builder. Please use the following code to verify your email address:</p>
                
                <div class="code-box">
                    <div class="code">{verification_code}</div>
                </div>
                
                <p>This code will expire in 15 minutes.</p>
                <p>If you did not register for an account, please ignore this email.</p>
                
                <div class="footer">
                    <p>Best regards,<br>AZone Team</p>
                </div>
            </div>
        </body>
        </html>
        """
        
        # Plain text version
        text_body = f"""
Email Verification Code

Hello{' ' + username if username else ''},

Thank you for registering with AZone Bot Builder.

Your verification code is: {verification_code}

This code will expire in 15 minutes.

If you did not register for an account, please ignore this email.

Best regards,
AZone Team
        """
        
        # Attach parts
        part1 = MIMEText(text_body, 'plain')
        part2 = MIMEText(html_body, 'html')
        
        msg.attach(part1)
        msg.attach(part2)
        
        # Send email
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USERNAME, SMTP_PASSWORD)
            server.send_message(msg)
        
        return {'success': True, 'error': None}
    
    except Exception as e:
        print(f"Error sending email: {e}")
        # Fallback to console output
        print(f"\n{'='*60}")
        print(f"📧 EMAIL VERIFICATION CODE (Fallback)")
        print(f"{'='*60}")
        print(f"To: {to_email}")
        if username:
            print(f"Username: {username}")
        print(f"Verification Code: {verification_code}")
        print(f"{'='*60}\n")
        return {'success': True, 'error': str(e)}

