



(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)


(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

;; update package
(unless package-archive-contents
  (package-refresh-contents))

(setq load-prefer-newer t)

;; BASIC COSMETIC CHANGES

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)



;; BACKUP/AUTOSAVE FILES

(defconst config-savefile-dir (expand-file-name "emacs-savefiles" temporary-file-directory))
(unless (file-exists-p config-savefile-dir)
  (make-directory config-savefile-dir))


(setq make-backup-files nil)
(setq auto-save-file-name-transforms
      `((".*" ,config-savefile-dir t))) 

;; FONT
;; https://github.com/source-foundry/Hack
(add-to-list 'default-frame-alist
             '(font . "Hack-10"))

;; disable windows sound on "error" 
(setq visible-bell 1)

(setq user-emacs-directory "~/.emacs.d")
(setq default-directory "~/")
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))


;;disable splash screen and startup message
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)

;; ENABLE DESKTOP AUTO-SAVE
(desktop-save-mode 1)


;; TRANSPARENCY

(defun transparency-toggle ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 50) '(100 . 100)))))
(defun transparency (value)
   "Sets the transparency of the frame window. 0=transparent/100=opaque"
   (interactive "nTransparency Value 0 - 100 opaque:")
   (set-frame-parameter (selected-frame) 'alpha value))



;; LINE NUMBER IN FILES THAT HAVE CODE

(when (version<= "26.0.50" emacs-version )
  (add-hook 'prog-mode-hook #'display-line-numbers-mode))

;; PAREN HIGHLIGHTS

(show-paren-mode 1)



;;                         _
;;  _ __     __ _    ___  | | __   __ _    __ _    ___   ___
;; | '_ \   / _` |  / __| | |/ /  / _` |  / _` |  / _ \ / __|
;; | |_) | | (_| | | (__  |   <  | (_| | | (_| | |  __/ \__ \
;; | .__/   \__,_|  \___| |_|\_\  \__,_|  \__, |  \___| |___/
;; |_|                                    |___/
;;

(unless (package-installed-p 'use-package)
  (package-install 'use-package))


(require 'use-package)
(setq use-package-verbose t)


;; SPACELINE

(use-package spaceline-config
	     :config
	     (spaceline-spacemacs-theme))


;; DOOM THEME

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t	   ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
	   
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
	     
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)

  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors")
  ;; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))
	   


;; AUTO COMPILE

(use-package auto-compile
  :config
  (auto-compile-on-load-mode)
  (auto-compile-on-save-mode))	     
	   

;; WINUM

(use-package auto-compile
  :config
  (setq winum-auto-setup-mode-line nil)
  (winum-mode))
	     
;; NYAN MODE

(use-package nyan-mode
  :config
  (setq nyan-wavy-trail t)
  (nyan-start-animation))


(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle))


;; VERTICAL FILE SUGESTIONS

(use-package ido-vertical-mode
  :config
  (ido-mode 1)
  (ido-vertical-mode 1)
  (setq ido-vertical-define-keys 'C-n-and-C-p-only))

;; PROJECTILE

(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-project-search-path '("/Github/" "~/Documents/"))	     


  (projectile-register-project-type 'cmake '("CMakeLists.txt")
				  :project-file "CMakeLists.txt"
				  :compilation-dir "build"
				  :src-dir "src"
				  :compile "cmake .. && cmake --build ."
				  :run "cmake --build ./build --target RUN"))
;; CHEATSHEET

(use-package cheatsheet
  :config
  (cheatsheet-add-group 'Common
			'(:key "C-x w <n>" :description "select window <n>")
			'(:key "C-x C-c"   :description "leave Emacs"))
  (cheatsheet-add-group 'Files/Buffers
			'(:key "C-x C-f"   :description "open file")
			'(:key "C-x C-s"   :description "save buffer")
			'(:key "C-x s"	   :description "save all buffers connected to file")
			'(:key "C-x C-w"   :description "save as")
			'(:key "C-x i"	   :description "insert")
			'(:key "C-x C-b"   :description "list open buffers")
			'(:key "C-x b"	   :description "move to or create buffer")
			'(:key "C-x ->"    :description "move to next buffer")
			'(:key "C-x <-"    :description "move to last buffer")
			'(:key "C-x k"     :description "kill buffer")
			'(:key "C-x C-q"   :description "toggle buffer read-only"))
  (cheatsheet-add-group 'Windows
			'(:key "|C-x| 0"   :description "close current")
			'(:key "|C-x| 1"   :description "close all but current")
			'(:key "C-x 2"     :description "split horizontally")
			'(:key "C-x 3"     :description "split vertically")
			'(:key "C-x o"     :description "switch window")
			'(:key "C-x ^"     :description "expand vertically")
			'(:key "C-x {"     :description "expand horizontally")
			'(:key "C-x -"     :description "shrink to buffer")
			'(:key "C-x +"     :description "equalize size"))
  (cheatsheet-add-group 'Navigation
			'(:key "C-p"       :description "previous line")
			'(:key "C-n"       :description "next line")
			'(:key "C-a"       :description "line beginning")
			'(:key "C-e"       :description "line end")
			'(:key "C-f"       :description "forward character")
			'(:key "C-b"       :description "backward character")
			'(:key "M-f"       :description "forward word")
			'(:key "M-b"       :description "backward word")
			'(:key "M-a"       :description "start of sentence")
			'(:key "M-e"       :description "end of sentence")
			'(:key "M-{"       :description "start of paragraph")
			'(:key "M-}"       :description "end of paragraph")
			'(:key "C-v"       :description "next screen")
			'(:key "M-v"       :description "previous screen")
			'(:key "M-<"       :description "start of buffer")
			'(:key "M->"       :description "end of buffer")
			'(:key "M-g M-g"   :description "go to line")
			'(:key "C-l"       :description "center display"))
  (cheatsheet-add-group 'Mark
			'(:key "C-space"   :description "by line")
			'(:key "C-x space" :description "by column")
			'(:key "C-x C-x"   :description "go to other side of region")
			'(:key "M-h"       :description "mark paragraph")
			'(:key "C-x C-p"   :description "mark current page")
			'(:key "C-x h"     :description "mark whole buffer"))
  (cheatsheet-add-group 'Editing
			'(:key "C-d"       :description "delete character forward")
			'(:key "M-d"       :description "cut word forward")
			'(:key "M-DEL"     :description "cut word backward")
			'(:key "C-k"       :description "cut to end of line")
			'(:key "C-w"       :description "cut selected region")
			'(:key "M-w"       :description "copy selected region")
			'(:key "C-y"       :description "paste")
			'(:key "M-y"       :description "next killed item")
			'(:key "C-x u"     :description "undo"))
  (cheatsheet-add-group 'Search
			'(:key "C-s"       :description "search forward")
			'(:key "C-r"       :description "search backwards"))
  (cheatsheet-add-group 'Projectile
			'(:key "C-c p p"   :description "switch project")
			'(:key "C-c p f"   :description "find file in project")
			'(:key "C-c p d"   :description "list all directories in project")
			'(:key "C-c p l"   :description "list all files in directory")
			'(:key "C-c p S"   :description "save all project buffers")
			'(:key "C-c p b"   :description "list all project buffers")
			'(:key "C-c p e"   :description "list of recent project files")
			'(:key "C-c p k"   :description "kill all project buffers")
			'(:key "C-c p !"   :description "run shell command in project"))
  (cheatsheet-add-group 'Neotree
			'(:key "n"	   :description "next line")
			'(:key "p"	   :description "previous line")
			'(:key "space"	   :description "open file or expand directory")
			'(:key "U"	   :description "go up a directory")
			'(:key "g"	   :description "refresh")
			'(:key "A"	   :description "maximize/minimize neotree")
			'(:key "H"	   :description "toggle display hidden files")
			'(:key "O"	   :description "recursively open directory")
			'(:key "C-c C-n"   :description "create file or directory")
			'(:key "C-c C-d"   :description "delete file or directory")
			'(:key "C-c C-r"   :description "rename file or directory")
			'(:key "C-c C-c"   :description "change root directory")
	    		'(:key "C-c C-p"   :description "copy file or directory")))	
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(use-package winum svg-tag-mode spaceline projectile nyan-mode neotree magit ido-vertical-mode helm flycheck doom-themes auto-compile all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
