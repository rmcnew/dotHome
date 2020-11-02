;; customize appearance
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(display-day-and-date nil)
 '(display-default-load-average nil)
 '(display-time-24hr-format t)
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(lisp-indent-offset 4)
 '(package-selected-packages (quote (exec-path-from-shell cider slime)))
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(toolbar-captioned-p nil)
 '(toolbar-visible-p nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "grey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 126 :width normal :foundary "bitstream" :family "Courier 10 Pitch")))))

;; sloppy focus
(setq focus-follows-mouse t)
(setq mouse-autoselect-window t)

;; join lines like Vim's J command
(defun top-join-line ()
    "Join the current line with the line beneath it."
    (interactive)
    (delete-indentation 1))
(global-set-key (kbd "C-J") 'top-join-line)

;; paren matching like Vim's % command
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key (kbd "C-%") 'goto-match-paren)

;; Use cperl-mode for better perl indenting
(fset 'perl-mode 'cperl-mode)
(setq cperl-indent-level 4
      cperl-close-paren-offset -4
      cperl-continued-statement-offset 4
      cperl-indent-parens-as-block t
      cperl-tab-always-indent t)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(setq inferior-lisp-program "/data/data/com.termux/files/usr/local/bin/ecl")
(setq slime-contribs '(slime-fancy))
