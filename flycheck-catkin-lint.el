;;; flycheck-cakin-lint.el --- Help to comply with the catkin_lint

;; Copyright (C) 2018  Yuto Mori

;;; Commentary:

;;;; Setup
;; (with-eval-after-load 'flycheck
;;   (require 'flycheck-catkin-lint))

;;;; Customize
;; (custom-set-variables
;;  '(flycheck-catkin-lint-warning-level "2")
;;  )

;;; Code:

(require 'flycheck)

(flycheck-def-option-var flycheck-catkin-lint-warning-level "1" cmake-catkin-lint
  "-W LEVEL : set warning level (0-2)"
  :type '(string :tag "Warning level")
  :safe #'stringp
  )

;; (flycheck-def-option-var flycheck-catkin-lint-ignore-id nil cmake-catkin-lint
;;   "--ignore ID : ignore diagnostic message ID"
;;   :type '(string :tag "IDs")
;;   :safe #'stringp
;;   )

(flycheck-define-checker cmake-catkin-lint
  "A Catkin style checker using catkin_lint.

See URL
`https://github.com/fkie/catkin_lint'."
  :command ("catkin_lint" "-q"
            (option "-W " flycheck-catkin-lint-warning-level concat)
            ;; (option "--ignore " flycheck-catkin-lint-ignore-id concat)
            (eval (file-name-directory (buffer-file-name)))
            )
  :error-patterns
  (
   (error line-start (zero-or-more not-newline)
          ": " (file-name) "\(" line "\)"
          ": error: " (message) line-end)
   (warning line-start (zero-or-more not-newline)
            ": " (file-name) "\(" line "\)"
            ": warning: " (message) line-end)
   (info line-start (zero-or-more not-newline)
         ": " (file-name) "\(" line "\)"
         ": notice: " (message) line-end)
   (error line-start (zero-or-more not-newline)
          ": error: " (message) line-end)
   (warning line-start (zero-or-more not-newline)
            ": warning: " (message) line-end)
   (info line-start (zero-or-more not-newline)
         ": info: " (message) line-end)
   )
  :error-filter flycheck-fill-empty-line-numbers
  :modes (cmake-mode))

(add-to-list 'flycheck-checkers 'cmake-catkin-lint 'append)

(provide 'flycheck-catkin-lint)

;;; flycheck-catkin-lint.el ends here
