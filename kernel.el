;;; kernel.el --- Minor mode for Linux kernel development

;; Copyright (C) 2020 Brian Kubisiak <brian@kubisiak.com>
;;
;; Author: Brian Kubisiak <brian@kubisiak.com>
;; URL: http://github.com/velentr/kernel-mode

;;; Commentary:

;; Minor mode for Linux kernel development.

;;; Code:

(defvar kernel-source-tree (expand-file-name "~/src/linux")
  "Path to the source tree for kernel headers.")

(defvar kernel-build-dir (expand-file-name "~/src/linux")
  "Path to the build outputs for the kernel tree.

This path should typically be the path that is passed with O= to the
kernel build.  It will be used for finding generated header files when
checking syntax.")

(defvar kernel-arch "x86"
  "Value of the ARCH= variable passed to the kernel build.")

(define-minor-mode kernel-mode
  "Minor mode for Linux kernel development."
  :init-value nil
  :lighter " Kernel"
  :keymap nil
  (cond
   (kernel-mode
    (c-set-style "linux")
    (setq tab-width 8)
    (setq indent-tabs-mode t)
    (custom-set-variables
     ;; The kernel build also uses -nostdinc -isystem
     ;; /usr/lib/gcc-cross/aarch64-linux-gnu/5/include, but I'm not
     ;; sure how to make that portable yet. Also, setting
     ;; CROSS_COMPILE= may be necessary for some parts of the kernel.
     '(flycheck-gcc-language-standard "gnu89")
     '(flycheck-gcc-includes
       `(,(concat kernel-source-tree "/include/linux/kconfig.h")))
     '(flycheck-gcc-definitions '("__KERNEL__"))
     '(flycheck-gcc-warnings
       '("all"
	 "undef"
	 "strict-prototypes"
	 "no-trigraphs"
	 "error-implicit-function-declaration"
	 "no-format-security"
	 "frame-larger-than=2048"
	 "no-unused-but-set-variable"
	 "declaration-after-statement"
	 "no-pointer-sign"
	 "error=implicit-int"
	 "error=strict-prototypes"
	 "error=date-time"
	 "error=incompatible-pointer-types"))
     '(flycheck-gcc-include-path
       `(,(concat kernel-source-tree "/arch/" kernel-arch "/include")
	 ,(concat kernel-build-dir "/arch/" kernel-arch "/include/generated/uapi")
	 ,(concat kernel-build-dir "/arch/" kernel-arch "/include/generated")
	 ,(concat kernel-source-tree "/include")
	 ,(concat kernel-build-dir "/include")
	 ,(concat kernel-source-tree "/arch/" kernel-arch "/include/uapi")
	 ,(concat kernel-source-tree "/include/uapi")
	 ,(concat kernel-build-dir "/include/generated/uapi")))))))

(provide 'kernel)

;;; kernel.el ends here
