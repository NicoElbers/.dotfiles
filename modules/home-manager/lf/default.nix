{ pkgs, stdenv, lib, ... }:
let
    gs = "${pkgs.ghostscript_headless}/bin/gs";
    gm = "${pkgs.graphicsmagick}/bin/gm";
    functions = pkgs.writeShellScript "functions.sh" ''
        #!${pkgs.bash}

        # Transmits an image in png format via file-mode transmission.
        #   $1 file path
        #   $2 image id
        transmit_file_png() {
            abspath_b64="$(printf -- "$(realpath -- "$1")" | base64 -w0)"
            printf "\e_Gt=f,i=$2,f=100,q=1;$abspath_b64\e\\" >/dev/tty
        }

        # Displays an already transferred image.
        #   $1 image id
        #   $2 placement id
        #   $3 x, $4 y, $5 w, $6 h
        display_img() {
            printf "\e[s" >/dev/tty # save cursor position
            tput cup $4 $3 >/dev/tty # move cursor
            printf "\e_Ga=p,i=$1,p=$2,c=$5,r=$6,q=1\e\\" >/dev/tty
            printf "\e[u" >/dev/tty # restore cursor position
        }

        # Deletes a displayed image.
        #   $1 image id
        #   $2 placement id
        delete_img() {
            printf "\e_Ga=d,d=I,i=$1,p=$2,q=1\e\\" >/dev/tty
        }

        # # Calculates the aspect ratio of the 
        # #   $1 file path
        # #   $2 maximum width
        # #   $3 maximum height
        # width_height_calc() {
        #     read actual_w actual_h <<< ${gm} identify -format "%w %h" "$1"
        #     max_w="$2"
        #     max_h="$3"
        #
        #     aspect_ratio=$(expr "$actual_w" / "$actual_h")
        #
        #     target_w=$(expr "$max_w" \* $aspect_ratio)
        #     target_h=$(expr "$max_h" \* $aspect_ratio)
        #
        #     if [ $target_w -le $max_w ]; then
        #         echo "$target_w $max_h"
        #     else
        #         echo "$max_w $target_h"
        #     fi
        # }


        # Combines transmit_file_png and display_img.
        #   $1 file path
        #   $2 image id
        #   $3 placement id
        #   $4 x, $5 y, $6 w, $7 h
        show() {
            transmit_file_png "$1" "$2"
            display_img "$2" "$3" "$4" "$5" "$6" "$7"
        }

        "$@"
    '';
in 
{
  config = {
    home.packages = [
      (pkgs.callPackage ./gorun.nix {})
    ];

    programs.lf = {
      enable = true;

      package = pkgs.writeShellApplication {
        name = "lf";
        runtimeInputs = [ pkgs.lf ];
        text = ''
            TMP_DIR="$(mktemp -d -t lf-kitty-XXXXXX)"
            IMG_ID=1234

            cleanup() {
                ${functions} delete_img "$IMG_ID" 0
                rm -rf "$TMP_DIR"
            }
            trap cleanup INT HUP

            LF_KITTY_TEMPDIR=$TMP_DIR \
            LF_KITTY_IMAGE_ID=$IMG_ID \
            lf -last-dir-path "$TMP_DIR/lastdir" "$@"

            if [ -e "$TMP_DIR/lastdir" ] && \
                dir="$(cat "$TMP_DIR/lastdir")" 2>/dev/null; then
                exec cd "$dir"
            fi

            cleanup
        '';
      };

      extraConfig = ''
        set cleaner ${pkgs.writeShellScript "cleaner.sh" ''
            #!${pkgs.bash}
            ${functions} delete_img $LF_KITTY_IMAGE_ID 0
        ''}
      '';

      previewer.source = (pkgs.writeShellScript "preview.sh" ''
        #!${pkgs.bash}

        # Called by lf to generate the preview.
        #   $1 file path
        #   $4 x offset in cell coordinates
        #   $5 y offset in cell coordinates
        #   $2 width of the display area in cell coordinates
        #   $3 height of the display area in cell coordinates
        THUMBNAIL_FPATH="$LF_KITTY_TEMPDIR/thumbnail.png"

        case "$(basename -- "$1" | tr '[:upper:]' '[:lower:]')" in
        *.png)
            ${functions} show "$1" $LF_KITTY_IMAGE_ID 1 $4 $5 $2 $3
            ;;
        *.pdf)
            ${gs} -o "$THUMBNAIL_FPATH" -sDEVICE=pngalpha -dLastPage=1 "$1" >/dev/null
            ${functions} show "$THUMBNAIL_FPATH" $LF_KITTY_IMAGE_ID 1 $4 $5 $2 $3
            ;;
        *.gif)
            ${gm} convert "$${1}[0]" "$THUMBNAIL_FPATH"
            ${functions} show "$THUMBNAIL_FPATH" $LF_KITTY_IMAGE_ID 1 $4 $5 $2 $3
            ;;
        *.jpg|*.jpeg|*.bmp|*.svg)
            ${gm} convert "$1" "$THUMBNAIL_FPATH"
            ${functions} show "$THUMBNAIL_FPATH" $LF_KITTY_IMAGE_ID 1 $4 $5 $2 $3
            ;;
        *)
            cat "$1"
            ;;
        esac
        exit 127
      '');
    };
  };
}
