#include 'set.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'
#include 'tbox.ch'

// 24.07.23
function cre_pas(par)
  local s, s1, c, i, cPassword, j
  local a1, a2, a3
  local oBox
  local n_reestr, msmo, mgod, mschet

  do while .t.

    n_reestr := 0
    msmo := 34007
    mgod := 0
    mschet := space(15)
    a1 := a2 := a3 := 0
    
      j := 10
    oBox := TBox():New( j, 10, j + 5, 70, .t. )
    oBox:ChangeAttr := .t.
	  oBox:CaptionColor := color8
	  oBox:Caption := 'Генерация пароля для отмены регистрации документа'
	  // oBox:Color := color1
    oBox:Save := .t.
    oBox:View()

    if par == 1
      @ 2, 1 TBOX oBox say 'Введите номер реестра' get n_reestr pict '999999'
    elseif par == 2
      @ 2, 1 TBOX oBox say 'Введите имя файла - A(D)S(T)' get msmo pict '99999'
      @ 2, 36 TBOX oBox say 'M999999_' get mgod pict '9999999'
    elseif eq_any(par, 3, 4)
      @ 2, 1 TBOX oBox say 'Введите имя счёта (с буквой)' get mschet pict '@!'
    endif
    @ 3, 1 TBOX oBox say 'Введите номер версии' get a1 pict '99'
    @ 3, 24 TBOX oBox say ',' get a2 pict '99'
    @ 3, 28 TBOX oBox say ',' get a3 pict '99'
    read
    if lastkey() == 27
      exit
    else
      if par == 1
        s := ltrim(str(n_reestr))
      elseif par == 2
        s := right(str(msmo), 1) + ltrim(str(mgod))
      elseif eq_any(par, 3, 4)
        s := iif(par == 3, '', '1')
        s1 := substr(alltrim(mschet), 3)
        for i := 1 to len(s1)
          c := substr(s1, i, 1)
          if between(c, '0', '9')
            s += c
          elseif between(c, 'A', 'Z')
            s += lstr(asc(c))
          endif
        next
      endif
      s := charrem('0', s) + ltrim(str(a1)) + ltrim(str(a2)) + ltrim(str(a3 * 7, 10, 0))
      do while len(s) > 7
        s := left(s, len(s) - 1)
      enddo
      cPassword := ntoc(s, 8)
      // вывод пароля (cPassword)
      hb_Alert(cPassword)
    endif
    oBox := nil
  enddo
  
  return nil