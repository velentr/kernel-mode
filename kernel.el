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
     '(flycheck-gcc-include-path
       `(,(concat kernel-source-tree "/include")))))
   (t
    (custom-set-variables
     '(flycheck-gcc-include-path '())))))

(provide 'kernel)

;;; kernel.el ends here
