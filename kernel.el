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

(defvar kernel-vendor-include-path '()
  "List of paths to vendor-provided include directories.

When working on kernel trees for vendor-supplied kernels, custom
include paths are often required for out-of-tree headers.  These paths
may be added to this variable and the paths will be passed with -I to
flycheck.")

(defvar kernel-arch "x86"
  "Value of the ARCH= variable passed to the kernel build.")

(define-minor-mode kernel-mode
  "Minor mode for Linux kernel development."
  :init-value nil
  :lighter (" Kernel/" kernel-arch)
  :keymap nil
  (cond
   (kernel-mode
    (c-set-style "linux")
    (setq tab-width 8)
    (setq indent-tabs-mode t)
    (let ((source-arch-path (concat kernel-source-tree "/arch/" kernel-arch))
          (build-arch-path (concat kernel-build-dir "/arch/" kernel-arch)))
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
       `(flycheck-gcc-include-path
         (append
          ,kernel-vendor-include-path
          `(,(concat source-arch-path "/include")
            ,(concat build-arch-path "/include/generated/uapi")
            ,(concat build-arch-path "/include/generated")
            ,(concat kernel-source-tree "/include")
            ,(concat kernel-build-dir "/include")
            ,(concat source-arch-path "/include/uapi")
            ,(concat kernel-source-tree "/include/uapi")
            ,(concat kernel-build-dir "/include/generated/uapi")))))))))

(provide 'kernel)

;;; kernel.el ends here
