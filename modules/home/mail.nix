# mbsync/notmuch/neomutt mail stack. Not used on particle-arts.
{ config, lib, pkgs, ... }:
{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
      postNew = ''
        # Tag new spam from presence of SpamAssassin X-Spam-Flag header
        notmuch tag +spam -inbox tag:inbox XSpamFlag:YES

        # Tag new drafts from other clients
        notmuch tag +draft -inbox -unread tag:inbox folder:/Drafts/

        # Tag new sent mail
        notmuch tag +sent -inbox -unread tag:inbox folder:/Sent/
      '';
    };
    new.tags = [
      "unread"
      "inbox"
    ];
    search.excludeTags = [
      "deleted"
      "spam"
    ];
    extraConfig = {
        # Index headers for easier searching
        index = {
            "header.XSpamFlag" = "X-Spam-Flag";
        };
    };
  };
  programs.neomutt = {
    enable = true;
    extraConfig = ''
      set quit
      unset mark_old
      set timeout=0
      unset markers

    bind attach <return>    view-mailcap

    set query_command="abook --mutt-query '%s'"
    macro index,pager a \
        "<pipe-message>abook --add-email-quiet<return>" \
        "Add this sender to abook"
    bind editor <Tab> complete-query

    set virtual_spoolfile
    virtual-mailboxes \
        "Inbox"     "notmuch://?query=tag:inbox not tag:archive"\
        "Void"     "notmuch://?query=not tag:inbox not tag:archive"\
        "Sent"      "notmuch://?query=tag:sent"\
        "Spam"      "notmuch://?query=tag:spam"\
        "Archived"     "notmuch://?query=tag:archive"

    set index_format="%4C %[%b %d %y] %zs %-15.15L (%?l?%4l&%4c?) %s"

    # notmuch bindings
    macro index \\\\ "<vfolder-from-query>"              # looks up a hand made query
    macro index A "<modify-labels>+archive -unread -inbox\n"        # tag as Archived
    macro index I "<modify-labels>-inbox -unread\n"                 # removed from inbox
    macro index S "<modify-labels-then-hide>-inbox -unread +spam\n" # tag as spam
    bind index,pager T modify-labels

    # Sidebar
    set sidebar_visible=no
    bind index <left> sidebar-prev          # got to previous folder in sidebar
    bind index <right> sidebar-next         # got to next folder in sidebar
    bind index <space> sidebar-open         # open selected folder from sidebar
    bind index,pager B sidebar-toggle-visible

    # Don't prompt for recipients on command line, let me edit manually
    set edit_headers
    set autoedit

    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats
    set sidebar_divider_char = '│'
    unset confirmappend      # don't ask, just do!
    set quit                 # don't ask, just do!!

    #------------------------------------------------------------
    # Vi Key Bindings
    #------------------------------------------------------------

    # Moving around
    bind attach,browser,index       g   noop
    bind attach,browser,index       gg  first-entry
    bind attach,browser,index       G   last-entry
    bind pager                      g  noop
    bind pager                      gg  top
    bind pager                      G   bottom
    bind pager                      k   previous-line
    bind pager                      j   next-line

    bind index,browser,pager                      r  noop
    bind index,browser,pager                      rr  reply
    bind index,browser,pager                      gr  group-reply

    # Scrolling
    bind attach,browser,pager,index \CF next-page
    bind attach,browser,pager,index \CB previous-page
    bind attach,browser,pager,index \Cu half-up
    bind attach,browser,pager,index \Cd half-down
    bind browser,pager              \Ce next-line
    bind browser,pager              \Cy previous-line
    bind index                      \Ce next-line
    bind index                      \Cy previous-line

    bind pager,index                d   noop
    bind pager,index                dd  delete-message

    # Threads
    bind browser,pager,index        N   search-opposite
    bind pager,index                dT  delete-thread
    bind pager,index                dt  delete-subthread
    bind pager,index                gt  next-thread
    bind pager,index                gT  previous-thread
    bind index                      za  collapse-thread
    bind index                      zA  collapse-all # Missing :folddisable/foldenable

    set mailcap_path = ~/.mailcaprc
    auto_view text/html
    '';
  };
  accounts.email = {
    maildirBasePath = "mail";
    accounts.wesl-ee = {
      address = "w@wesl.ee";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp = {
        enable = true;
        tls.fingerprint = "1D:E7:94:6A:3A:A3:1E:54:A4:59:DF:51:E1:7F:70:1E:8A:FC:54:D0:3E:C2:63:95:5A:C4:F2:B6:FD:7D:D1:99";
        extraConfig = {
          port = "587";
          tls_starttls = "on";
        };
      };
      notmuch.enable = true;
      neomutt.enable = true;
      primary = true;
      passwordCommand = "pass email/w@wesl.ee";
      imap.host = "gyw.wesl.ee";
      smtp.host = "gyw.wesl.ee";
      realName = "Wesley Coakley";
      userName = "w@wesl.ee";
    };
  };
}
