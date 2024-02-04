from os import system, getuid
import subprocess
import sys

class Update_bg:
    def __init__(self):
        self.timezone = "TZVAR"
        self.ntbg = f"https://ntbg.app/NSFWVAR{self.timezone}"
        self.wp_file1 = "/etc/animebg/current_wp1"
        self.wp_file2 = "/etc/animebg/current_wp2"
        self.current_wp = ""
        self.user_id = str(getuid())
        self.get_bg()
        self.set_bg()
    
    def get_bg(self):
        self.current_wp = subprocess.check_output(f"DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/{self.user_id}/bus' gsettings get org.gnome.desktop.background picture-uri-dark", shell=True)
        self.current_wp = self.current_wp.decode("utf-8").strip().replace("'", "")
    
    def set_bg(self):
        if self.current_wp == f"file://{self.wp_file1}":
            self.write_wp(self.wp_file2)
            system(f"DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/{self.user_id}/bus' gsettings set org.gnome.desktop.background picture-uri-dark 'file://{self.wp_file2}'")
            system(f"DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/{self.user_id}/bus' gsettings set org.gnome.desktop.background picture-uri 'file://{self.wp_file2}'")
        else:
            self.write_wp(self.wp_file1)
            system(f"DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/{self.user_id}/bus' gsettings set org.gnome.desktop.background picture-uri-dark 'file://{self.wp_file1}'")
            system(f"DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/{self.user_id}/bus' gsettings set org.gnome.desktop.background picture-uri 'file://{self.wp_file1}'")
    
    def write_wp(self, wp_file):
        system(f"wget -O {wp_file} {self.ntbg}")

bg = Update_bg()
sys.exit()
