;;; GEOS-vote.el --- An easy way to respond to GEOS ballots.

;; Copyright (C) 1998 by Tom Breton

;; Time-stamp: <1998-11-07 22:24:19 Tehom>
;; Author: Tom Breton <Tehom@localhost>
;; Keywords: mail
;; Version: 1.1

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Installation:

;; Put GEOS-vote.el somewhere in your load path.

;; Put 
;;  (autoload 'GEOS-vote "GEOS-vote" 
;;    "Efficiently perform GEOS-style email votes." t) 
;;in your .emacs

;; Load GEOS-vote and type M-x customize.  GEOS options are under
;; Local.  This assumes you have been to the GEOS site, otherwise you
;; won't know what to put.

;;; Usage:

;; When GEOS emails you a ballot, read it normally and type M-x
;; GEOS-vote.  You'll be prompted for a numerical score and left in a
;; mail buffer that should be ready to mail.  

;;; Commentary:

;; This code is only meaningful in conjunction with gnus and GEOS
;; ballots.  It is invoked with M-x GEOS-vote in the gnus' *Article*
;; buffer when reading a GEOS ballot.

;; GEOS (Global Episode Opinion Survey) is a sort of ratings system in
;; which viewers rank the quality of episodes of television shows and
;; GEOS summarizes the results.  See <http://www.swd.net.au/geos/> for
;; more details.

;;Changelog:

;; 1998-11-07 22:24:19 Tehom
;; Made GEOS-vote check whether gnus is running and that the current
;; buffer is named *Article* and complain if it's not.  

;; 1998-11-07 22:19:40 Tehom  
;; Added a better suggested autoload to the installation instructions.

  
;;; Code:


(defgroup GEOS-vote nil "Required customization for GEOS-vote"
  :group 'local)

(defcustom GEOS-user-first-name "Exit and type M-x customize"
  "*Your first name."
  :tag "Your first name"
  :type 'string
  :group 'GEOS-vote)

(defcustom GEOS-user-last-name "GEOS options are under Local"
  "*Your last name."
  :tag "Your last name"
  :type 'string
  :group 'GEOS-vote)

(defcustom GEOS-user-PIN 0
  "*Your GEOS PIN."
  :tag "Your PIN as you gave it on the GEOS website"
  :type 'integer
  :group 'GEOS-vote)

;;;###autoload
(defun GEOS-vote (score)
  "Efficiently perform GEOS-style email votes.

See <http://www.swd.net.au/geos/> for more details.

This function assumes it is being invoked in the gnus *Article* buffer
when reading a GEOS ballot. It leaves the user in mail, which can be
sent by the usual commands or edited if not satisfactory."

  (interactive "NWhat score do you give? (0.0 to 10.0) ")

  ;;Only run if gnus is running and we're in the proper buffer,
  ;;otherwise explain the problem and abort. 
  (if
    (not
      (and 
	(fboundp 'gnus-alive-p) 
	(gnus-alive-p)
	(equal (buffer-name) "*Article*")))

    (error "GEOS-vote should only be invoked in gnus, in the *Article*
buffer when reading a GEOS ballot" )
    

    (let
      (show-ID episode-ID vote-string)


      (save-excursion
	(goto-char (point-min))
	(re-search-forward 
	  "YourLastname:YourFirstname:YourPIN:\\([^:]+\\):\\([^:]+\\):YourScore")

	(setq show-ID (match-string 1))
	(setq episode-ID (match-string 2))
	(setq vote-string 
	  (format "%s:%s:%s:%s:%s:%s" 
	    GEOS-user-last-name 
	    GEOS-user-first-name 
	    (number-to-string GEOS-user-PIN) 
	    show-ID 
	    episode-ID 
	    score )))

    
      (gnus-summary-reply nil)
      (insert vote-string ))))


;;Suitable for the multi-way ballot style.  There would have to be
;;considerable work done before this would work nicely.
(defun GEOS-vote-multiway (score)
  "Efficiently perform GEOS-style email votes.

See <http://www.swd.net.au/geos/> for more details.

This function assumes it is being invoked in the gnus *Article* buffer
when reading a GEOS ballot. It leaves the user in mail, which can be
sent by the usual commands or edited if not satisfactory."

  (interactive "NWhat score do you give? (0.0 to 10.0) ")

  ;;Only run if gnus is running and we're in the proper buffer,
  ;;otherwise explain the problem and abort. 
  (if
    (not
      (and 
	(fboundp 'gnus-alive-p) 
	(gnus-alive-p)
	(equal (buffer-name) "*Article*")))

    (error "GEOS-vote should only be invoked in gnus, in the *Article*
buffer when reading a GEOS ballot" )
    

    (let
      (show-ID episode-ID vote-string)


      (save-excursion

	(re-search-forward 
	  "Lastname:Firstname:PIN:\\([^:]+\\):\\([^:]+\\):Score")

	(setq show-ID (match-string 1))
	(setq episode-ID (match-string 2))
	(setq vote-string 
	  (format "%s:%s:%s:%s:%s:%s" 
	    GEOS-user-last-name 
	    GEOS-user-first-name 
	    (number-to-string GEOS-user-PIN) 
	    show-ID 
	    episode-ID 
	    score )))

    
      (gnus-summary-reply nil)
      (insert vote-string ))))
 

;;; GEOS-vote.el ends here