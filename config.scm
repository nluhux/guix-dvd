(use-modules (gnu)
	     (gnu packages admin)
	     (gnu packages certs)
	     (gnu packages base)
	     (gnu packages screen)
	     (gnu packages tmux)
	     (gnu packages xorg)
	     (gnu packages radio)
	     (gnu packages wm)
	     (gnu packages terminals)
	     (gnu packages image)
	     (gnu packages xdisorg)
	     (gnu packages fontutils)
	     (gnu packages fonts)
	     (gnu packages gnome)
	     (gnu packages gnuzilla)
	     (gnu packages chromium)
	     (gnu packages w3m)
	     (gnu packages web-browsers)
	     (gnu packages video)
	     (gnu packages music)
	     (gnu packages libreoffice)
	     (gnu packages pdf)
	     (gnu packages cryptsetup)
	     (gnu packages linux)
	     (gnu packages disk)
	     (gnu packages cdrom)
	     (gnu packages networking)
	     (gnu packages ssh)
	     (gnu packages vnc)
	     (gnu packages rdesktop)
	     (gnu packages version-control)
	     (gnu packages ncurses)
	     (gnu packages rsync)
	     (gnu packages vpn)
	     (gnu packages task-management)
	     (gnu packages compression)
	     (gnu packages virtualization)
	     (gnu packages dictionaries)
	     (gnu packages dico)
	     (gnu packages vim)
	     (gnu packages mail)
	     (gnu packages ntp)
	     (gnu packages ed)
	     (gnu packages games)
	     (gnu packages ftp)
	     (gnu packages gdb)
	     (gnu services base)
	     (gnu services xorg)
	     (gnu services networking)
	     (gnu services dbus)
	     (gnu services desktop)
	     (gnu services linux)
	     )


(operating-system
 (host-name "guixdvd")
 (timezone "UTC")
 (locale "en_US.utf8")
 (keyboard-layout
  ;; 爱护Linux用户的手指.
  (keyboard-layout "us" #:options (list "ctrl:nocaps")))

 (kernel-arguments (append
		    ;; rtl-sdr 需要的设置
		    '("modprobe.blacklist=dvb_usb_rtl28xxu")
		    %default-kernel-arguments))

 (bootloader (bootloader-configuration
	      (bootloader grub-bootloader)
	      (targets '())))

 (file-systems
  (append (list
	   (file-system
	    (device (file-system-label "guixdvd-root"))
	    (mount-point "/")
	    (type "ext4")))
	  %base-file-systems))
 (users (append
	 (list

	  ;; 恶意代码的天堂
	  (user-account
	   (name "heaven")
	   (comment "Live in heaven")
	   (group "users")
	   (supplementary-groups
	    '("wheel" "audio" "video" "dialout" "kvm")))

	  ;; 恶意代码的炼狱
	  (user-account
	   (name "purgatory")
	   (comment "Live in purgatory")
	   (group "purgatory")
	   (supplementary-groups
	    '("audio" "video" "kvm")))

	  ;; 恶意代码的地狱
	  (user-account
	   (name "hell")
	   (comment "Live in hell")
	   (group "hell")
	   (supplementary-groups
	    '("audio" "video"))))))
 (groups (append
	  (list
	   (user-group (name "purgatory"))
	   (user-group (name "hell")))
	  %base-groups))

 (packages (append
	    (list
	     nss-certs    ;; TLS 证书
	     screen tmux  ;; 终端复用器
	     uim          ;; 终端输入法
	     rtl-sdr gqrx ;; 软件无线电
	     hikari foot grim wl-clipboard ;; Wayland 会话
	     fontconfig font-gnu-unifont ;; 字体
	     adwaita-icon-theme          ;; 图标
	     ;; Web浏览器
	     icecat ungoogled-chromium/wayland
	     w3m lynx links
	     mplayer cmus mpv ;; 媒体播放器
	     libreoffice      ;; 办公
	     zathura zathura-pdf-mupdf ;; PDF
	     cryptsetup ;; 磁盘加密
	     ;; 文件系统工具
	     btrfs-progs e2fsprogs xfsprogs
	     dosfstools cdrtools
	     tcpdump wireshark ;; 抓包工具
	     openssh dropbear ;; 远程shell工具
	     tigervnc-client freerdp ;; 远程桌面工具
	     alsa-utils ;; 音频设置工具
	     acpi ;; ACPI 工具
	     cpupower  ;; CPU性能设置工具
	     git ;; 版本控制工具
	     ncurses ;; 终端控制工具
	     htop bmon iotop iftop ;; 资源监控工具
	     rsync ;; 备份工具
	     wireguard-tools ;; VPN工具
	     blanket ;; 令人舒适的噪音播放器
	     unzip ;; 解压工具
	     qemu ;; 虚拟机
	     sdcv dico ;; 字典工具
	     vim ed ;; 编辑器
	     mutt fdm msmtp ;; 邮箱
	     ntp ;; 校时
	     cataclysm-dda nethack cmatrix gtypist tintin++ curseofwar ;; 游戏
	     picocom putty ;; 串口工具
	     macchanger ;; MAC地址更改工具
	     strace ltrace gdb  ;; 调试工具
	     iperf ;; 链路速度测试
	     nmap ;; 网络扫描工具
	     aircrack-ng iw wireless-tools wpa-supplicant ;; 80211无线网络工具
	     )
	    %base-packages))
 (services (append
	    (list
	     ;; 锁屏
	     (screen-locker-service hikari "hikari-unlocker")
	     (screen-locker-service kbd "vlock")
	     
	     ;; 默认拦截的防火墙规则
	     (service nftables-service-type
		      (nftables-configuration
		       (ruleset
			(local-file
			 "config.scm.d/nftables.rule"))))
	     ;; 支持CJK的终端模拟器
	     (service kmscon-service-type
		      (kmscon-configuration
		       (virtual-terminal "tty7")
		       (font-engine "unifont")
		       (keyboard-layout keyboard-layout)))
	     ;; 用于启动Wayland会话
	     (dbus-service)
	     (elogind-service)
	     
	     ;; Tor 服务
	     (service tor-service-type
		      (tor-configuration
		       (control-socket? #t)))

	     ;; Zram
	     (service zram-device-service-type)
	     
	     ;; rtl-sdr 需要的设置
	     (udev-rules-service 'rtl-sdr rtl-sdr)
	     )
	    %base-services)))
