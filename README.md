# Osaka ’09 SDDM Theme

**A retro‑nostalgic SDDM theme for Osaka '09, A retro Gentoo Linux Distro heavily based on the Windows 7 SDDM theme by [birbkeks](https://github.com/birbkeks/win7-sddm-theme).**  
This theme transforms your Linux login screen with a vintage city aesthetic reminiscent of early 2000s Osaka, while retaining the smooth animations and layout from the original Win7 theme.

---

## Preview

![preview](./osaka09-preview.png)  

---

## Features

- Directly adapted from the **Win7 SDDM theme** structure
- Osaka ’09 visual design and backgrounds
- Smooth login transitions
- Fully compatible with SDDM and QML
- Easy customization of backgrounds and colors

---

## Requirements

- **SDDM** (Simple Desktop Display Manager) installed  
- Qt and QML support (Qt6 recommended)  
- Optional: Osaka‑style fonts for full effect

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/viztini/osaka09-sddm-theme.git
````

### 2. Copy to SDDM themes directory

```bash
sudo cp -r osaka09-sddm-theme /usr/share/sddm/themes/
```

### 3. Set the theme in SDDM

Edit SDDM configuration:

```bash
sudo nano /etc/sddm.conf.d/kde_settings.conf
```

or

```bash
sudo nano /etc/sddm.conf
```

Add or update:

```ini
[Theme]
Current=osaka09-sddm-theme
```

### 4. Restart SDDM

```bash
sudo systemctl restart sddm
```

---

## Test the theme without logging out

```bash
env -i HOME=$HOME DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/osaka09-sddm-theme
```

---

## Customization

* Change background image: edit `background.png` in the theme folder
* Adjust colors and fonts in `theme.conf` if desired
* Edit user profile picture by swapping out the image

---

## Known Issues

* Some animations may differ between Wayland and X11
* On-screen keyboard support is not included

---

## Credits

* Original structure and logic: **[Win7 SDDM Theme](https://github.com/birbkeks/win7-sddm-theme)**
* Osaka ’09 redesign: *viztini*

---

## License

Distributed under the **GPL‑3.0 License** — see `LICENSE` for details.
