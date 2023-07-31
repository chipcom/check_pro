#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'
#include 'tbox.ch'

function begin_task_services()
  local dbName := '_mo_mo'
  local standart, uroven
  local _arr := {}

  Local row, arr_block, buf := savescreen()
  local tmpAlias, i
  
  private nRecno

  // _mo_mo.dbf - справочник медучреждений
  //  1 - MCOD(C)  2 - CODEM(C)  3 - NAMEF(C)  4 - NAMES(C) 5 - ADRES(C) 6 - MAIN(C)
  //  7 - PFA(C) 8 - PFS(C) 9 - PROD(C) 10 - DOLG(C) 
  //  11 - DEND(D)  12 - STANDART(C)  13 - UROVEN(C)

  // arr_block := {{|| FindFirst(str_find)}, ;
  //   {|| FindLast(str_find)}, ;
  //   {|n| SkipPointer(n, muslovie)}, ;
  //   str_find, muslovie;
  //    }

  dbUseArea( .t., , dir_server() + dbName, dbName, .f., .f. )
  Alpha_Browse(2, 0, maxrow() - 1, 79, 'f1_mo_mo', color0, 'Выбор организации', 'B/BG', ;
    .f., , arr_block, , 'f2_mo_mo', , ;
    {'═', '░', '═', 'N/BG, W+/N, B/BG, BG+/B, R/BG, W+/R, N+/BG, W/N, RB/BG, W+/RB', .t., 180} )

  if nRecno != 0
    standart := {}
    uroven := {}

    hb_jsonDecode( (dbName)->STANDART, @standart )
    hb_jsonDecode( (dbName)->UROVEN, @uroven )

    for each row in standart
      row[1] := hb_SToD(row[1])
    next
    for each row in uroven
      row[1] := hb_SToD(row[1])
    next

    _arr := { ;
        alltrim((dbName)->NAMES), ;
        alltrim((dbName)->CODEM), ;
        (dbName)->PROD, ;
        (dbName)->DEND, ;
        alltrim((dbName)->MCOD), ;
        alltrim((dbName)->NAMEF), ;
        uroven, ; // уровень оплаты, с 2013 года 4 - индивидуальные тарифы
        standart, ;
        (dbName)->MAIN == '1', ;
        (dbName)->PFA == '1', ;
        (dbName)->PFS == '1', ;
        alltrim((dbName)->ADRES) ;
      }
  endif
  (dbName)->(dbCloseArea())
  restscreen(buf)
  if len(_arr) != 0
    waitStatus()
    index_services(dir_server(), cur_dir(), _arr)
    restscreen(buf)
  endif
  return _arr

// 31.07.23
Function f1_mo_mo(oBrow)
  Local n := 50
  Local oColumn, blk := {|_c| _c := f0_mo_mo(), {{1, 2}, {3, 4}, {5, 6}, {7, 8}, {9, 10}}[_c]}

  oColumn := TBColumnNew(center('Код ТФОМС', 10), {|| left(_MO_MO->CODEM, 10)})
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew(center('Наименование организации', n), {|| left(_MO_MO->NAMES, n)})
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  status_key('^<Esc>^ выход ^<Enter>^ выбор ^<F2>^ поиск')
  return NIL
  
// 31.07.23
Function f0_mo_mo()
  Local k := 3, v1, v2, fl1del, fl2del  // , s := iif(empty(usl->shifr1), usl->shifr, usl->shifr1)

  // s := padr(transform_shifr(s), 10)
  // select LUSL
  // find (s)
  // if found()
  //   k := 4  // найдена, но нет цены
  //   v1 := fcena_oms(lusl->shifr, .t., sys_date, @fl1del)
  //   v2 := fcena_oms(lusl->shifr, .f., sys_date, @fl2del)
    if _MO_MO->DEND < sys_date
      k := 5  // удалена
  //   elseif !emptyall(v1, v2)
  //     k := 1  // есть цена
  //   endif
  // elseif !emptyall(usl->pcena, usl->pcena_d, usl->dms_cena)
  //   k := 2  // есть платная цена
    endif
  // select USL
    return k
  
// 25.07.23
Function f2_mo_mo(nKey, oBrow)
  Static sshifr := '          '
  LOCAL j := 0, k := -1
  local buf := save_maxrow(), buf1, fl := .f., rec, ;
        tmp_color := setcolor(), r1 := 14, c1 := 2

  nRecno := 0
  do case
    case nKey == K_UP
      oBrow:up()
    case nKey == K_DOWN
      oBrow:down()
    case nKey == K_ENTER
      nRecno := _mo_mo->(recno())
      k := 1
    case nKey == K_F2
      // rec := recno()
      // if (mshifr := input_value(18, 10, 20, 69, color1, ;
      //           '  Введите необходимый шифр услуги для поиска', ;
      //           sshifr, '@K@!')) != NIL
      //   sshifr := mshifr := transform_shifr(mshifr)
      //   set order to 3
      //   find (padr(mshifr, 10))
      //   if found()
      //     rec := recno()
      //     fl := .t.
      //   endif
      //   set order to 1
      //   if fl
      //     oBrow:goTop()
      //     goto (rec)
      //     k := 0
      //   else
      //     goto (rec)
      //     func_error(4, 'Услуга с шифром "' + alltrim(mshifr) + '" не найдена!')
      //   endif
      // endif
      // endif
  endcase
  rest_box(buf)
  return k
  
