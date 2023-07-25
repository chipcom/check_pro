** ࠧ���� �㭪樨 ��饣� ���짮����� ��� ࠡ��� � 䠩���� �� - use_func.prg
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

** 31.01.17
Function R_Use_base(sBase, lAlias)
  return use_base(sBase, lAlias, , .t.)

** 18.03.23 ����뢠�� ������ ��� lusl, luslc � luslf
function close_use_base(sBase)
  local countYear, lAlias

  sBase := lower(sBase) // �஢�ਬ, �� ����� ����� � �멤�� �᫨ ���, ���� lusl, luslc, luslf
  if ! substr(sBase, 1, 4) == 'lusl'
    return nil
  endif
  if select(sBase) == 0
    return nil
  endif

  for countYear := 2018 to WORK_YEAR
    lAlias := sBase + iif(countYear == WORK_YEAR, '', substr(str(countYear, 4), 3))
    // if exists_file_TFOMS(countYear, 'usl')
    if exists_file_TFOMS(countYear, substr(sBase, 2))
      if (lAlias)->(used())
        (lAlias)->(dbCloseArea())
      endif
    endif
  next
  return nil

** 12.03.23
function existsNSIfile(sbase, vYear)
  local fl := .f., fName, findex, fIndex_add

  fName := prefixFileRefName(vYear) + substr(sbase, 2)
  if (fl := hb_vfExists(exe_dir + fName + sdbf))
    do case
      case sBase == 'lusl'
        fIndex := cur_dir + fName + sntx
        if (fl := hb_vfExists(exe_dir + fName + sdbf))
          if ! hb_vfExists(fIndex)
            R_Use(exe_dir + fName, , sBase)
            index on shifr to (fIndex)
            (sBase)->(dbCloseArea())
          endif
        endif
    case sBase == 'luslc'
      fIndex := cur_dir + fName + sntx
      fIndex_add :=  prefixFileRefName(vYear) + 'uslu'  // 
      if (fl := hb_vfExists(exe_dir + fName + sdbf))
        if (! hb_vfExists(fIndex)) .or. (! hb_vfExists(cur_dir + fIndex_add + sntx))
          R_Use(exe_dir + fName, , sBase)
          // index on shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (cur_dir + sbase) ;
          index on shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (findex) ;
              for codemo == glob_mo[_MO_KOD_TFOMS]
          index on codemo + shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (cur_dir + fIndex_add) ;
              for codemo == glob_mo[_MO_KOD_TFOMS] // ��� ᮢ���⨬��� � ��ன ���ᨥ� �ࠢ�筨��
          (sBase)->(dbCloseArea())
        endif
      endif
    case sBase == 'luslf'
      fName := prefixFileRefName(vYear) + 'uslf'
      fIndex := cur_dir + fName + sntx
      if (fl := hb_vfExists(exe_dir + fName + sdbf))
        if ! hb_vfExists(fIndex)
          R_Use(exe_dir + fName, , sBase)
          index on shifr to (cur_dir + fName)
          (sBase)->(dbCloseArea())
        endif
      endif
    endcase
  endif
  return fl


// 10.04.23
Function use_base(sBase, lAlias, lExcluUse, lREADONLY)
  Local fl := .t., sind1 := '', sind2 := ''
  local fname, fname_add
  local countYear

  sBase := lower(sBase)
  do case
    case sBase == 'lusl'
      for countYear := 2018 to WORK_YEAR
        if exists_file_TFOMS(countYear, 'usl')
          fName := prefixFileRefName(countYear) + substr(sbase, 2)
          lAlias := create_name_alias(sBase, countYear)          
          if ! (lAlias)->(used())
            sind1 := cur_dir + fName + sntx
            if ! hb_vfExists(sind1)
              R_Use(exe_dir + fName, , lAlias)
              index on shifr to (sind1)
            else
              R_Use(exe_dir + fName, sind1, lAlias)
            endif
          endif
        endif
      next
      // fl := R_Use(exe_dir + '_mo8usl', cur_dir + '_mo8usl', sBase + '18') .and. ;
      //   R_Use(exe_dir + '_mo9usl', cur_dir + '_mo9usl', sBase + '19') .and. ;
      //   R_Use(exe_dir + '_mo0usl', cur_dir + '_mo0usl', sBase + '20') .and. ;
      //   R_Use(exe_dir + '_mo1usl', cur_dir + '_mo1usl', sBase + '21') .and. ;
      //   R_Use(exe_dir + '_mo2usl', cur_dir + '_mo2usl', sBase + '22') .and. ;
      //   R_Use(exe_dir + '_mo3usl', cur_dir + '_mo3usl', sBase)
    case sBase == 'luslc'
      for countYear := 2018 to WORK_YEAR
        if exists_file_TFOMS(countYear, 'uslc')
          fName := prefixFileRefName(countYear) + substr(sbase, 2)
          fname_add := prefixFileRefName(countYear) + substr(sbase, 2, 3) + 'u'
          lAlias := sBase + iif(countYear == WORK_YEAR, '', substr(str(countYear, 4), 3))
          if ! (lAlias)->(used())
            sind1 := cur_dir + fName + sntx
            sind2 := cur_dir + fname_add + sntx
            if ! (hb_vfExists(sind1) .or. hb_vfExists(sind2))
              R_Use(exe_dir + fName, , lAlias)
              index on shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (sind1) ;
                for codemo == glob_mo[_MO_KOD_TFOMS]
              index on codemo + shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (sind2) ;
                for codemo == glob_mo[_MO_KOD_TFOMS] // ��� ᮢ���⨬��� � ��ன ���ᨥ� �ࠢ�筨��
            else
              R_Use(exe_dir + fName, {cur_dir + fName, cur_dir + fName_add}, lAlias)
            endif
          endif
        endif
      next
      // fl := R_Use(exe_dir + '_mo8uslc', {cur_dir + '_mo8uslc', cur_dir + '_mo8uslu'}, sBase + '18') .and. ;
      //   R_Use(exe_dir + '_mo9uslc', {cur_dir + '_mo9uslc', cur_dir + '_mo9uslu'}, sBase + '19') .and. ;
      //   R_Use(exe_dir + '_mo0uslc', {cur_dir + '_mo0uslc', cur_dir + '_mo0uslu'}, sBase + '20') .and. ;
      //   R_Use(exe_dir + '_mo1uslc', {cur_dir + '_mo1uslc', cur_dir + '_mo1uslu'}, sBase + '21') .and. ;
      //   R_Use(exe_dir + '_mo2uslc', {cur_dir + '_mo2uslc', cur_dir + '_mo2uslu'}, sBase + '22') .and. ;
      //   R_Use(exe_dir + '_mo3uslc', {cur_dir + '_mo3uslc', cur_dir + '_mo3uslu'}, sBase)
    case sBase == 'luslf'
      for countYear := 2018 to WORK_YEAR
        if exists_file_TFOMS(countYear, 'uslf')
          fName := prefixFileRefName(countYear) + substr(sbase, 2)
          lAlias := sBase + iif(countYear == WORK_YEAR, '', substr(str(countYear, 4), 3))
          if ! (lAlias)->(used())
            sind1 := cur_dir + fName + sntx
            if ! hb_vfExists(sind1)
              R_Use(exe_dir + fName, , lAlias)
              index on shifr to (sind1)
            else
              R_Use(exe_dir + fName, cur_dir + fName, lAlias)
            endif
          endif
        endif
      next
      // fl := R_Use(exe_dir + '_mo8uslf', cur_dir + '_mo8uslf', sBase + '18') .and. ;
      //   R_Use(exe_dir + '_mo9uslf', cur_dir + '_mo9uslf', sBase + '19') .and. ;
      //   R_Use(exe_dir + '_mo0uslf', cur_dir + '_mo0uslf', sBase + '20') .and. ;
      //   R_Use(exe_dir + '_mo1uslf', cur_dir + '_mo1uslf', sBase + '21') .and. ;
      //   R_Use(exe_dir + '_mo2uslf', cur_dir + '_mo2uslf', sBase + '22') .and. ;
      //   R_Use(exe_dir + '_mo3uslf', cur_dir + '_mo3uslf', sBase)
    case sBase == 'organiz'
      DEFAULT lAlias TO 'ORG'
      fl := G_Use(dir_server + 'organiz', , lAlias, , lExcluUse, lREADONLY)
    case sBase == 'komitet'
      if (fl := G_Use(dir_server + 'komitet', , lAlias, , lExcluUse, lREADONLY))
        index on str(kod, 2) to (cur_dir + 'tmp_komi')
      endif
    case sBase == 'str_komp'
      if (fl := G_Use(dir_server + 'str_komp', , lAlias, , lExcluUse, lREADONLY))
        index on str(kod, 2) to (cur_dir + 'tmp_strk')
      endif
    case sBase == 'mo_pers'
      DEFAULT lAlias TO 'P2'
      fl := G_Use(dir_server + 'mo_pers',dir_server + 'mo_pers', lAlias, , lExcluUse, lREADONLY)
    case sBase == 'mo_su'
      DEFAULT lAlias TO 'MOSU'
      fl := G_Use(dir_server + 'mo_su', {dir_server + 'mo_su', ;
                                    dir_server + 'mo_sush', ;
                                    dir_server + 'mo_sush1'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'uslugi'
      DEFAULT lAlias TO 'USL'
      fl := G_Use(dir_server + 'uslugi', {dir_server + 'uslugi', ;
                                    dir_server + 'uslugish', ;
                                    dir_server + 'uslugis1', ;
                                    dir_server + 'uslugisl'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'kartotek'
      fl := G_Use(dir_server + 'kartote_', ,'KART_', , lExcluUse, lREADONLY) .and. ;
          G_Use(dir_server + 'kartote2', ,'KART2', , lExcluUse, lREADONLY) .and. ;
          G_Use(dir_server + 'kartotek', {dir_server + 'kartotek', ;
                                       dir_server + 'kartoten', ;
                                       dir_server + 'kartotep', ;
                                       dir_server + 'kartoteu', ;
                                       dir_server + 'kartotes', ;
                                       dir_server + 'kartotee'},'KART', , lExcluUse, lREADONLY)
      if fl
        set relation to recno() into KART_, to recno() into KART2
      endif
    case sBase == 'human'
      DEFAULT lAlias TO 'HUMAN'
      fl := G_Use(dir_server + 'human_', ,'HUMAN_', , lExcluUse, lREADONLY) .and. ;
          G_Use(dir_server + 'human_2', ,'HUMAN_2', , lExcluUse, lREADONLY) .and. ;
          G_Use(dir_server + 'human', {dir_server + 'humank', ;
                                    dir_server + 'humankk', ;
                                    dir_server + 'humann', ;
                                    dir_server + 'humand', ;
                                    dir_server + 'humano', ;
                                    dir_server + 'humans'}, lAlias, , lExcluUse, lREADONLY)
      if fl
        set relation to recno() into HUMAN_, to recno() into HUMAN_2
      endif
    case sBase == 'human_im'
      DEFAULT lAlias TO 'IMPL'
      fl := G_Use(dir_server + 'human_im', dir_server + 'human_im', lAlias, , lExcluUse, lREADONLY)
    case sBase == 'human_u'
      DEFAULT lAlias TO 'HU'
      fl := G_Use(dir_server + 'human_u_', ,'HU_', , lExcluUse, lREADONLY) .and. ;
          G_Use(dir_server + 'human_u', {dir_server + 'human_u', ;
                                      dir_server + 'human_uk', ;
                                      dir_server + 'human_ud', ;
                                      dir_server + 'human_uv', ;
                                      dir_server + 'human_ua'}, lAlias, , lExcluUse, lREADONLY)
      if fl
        set relation to recno() into HU_
      endif
    case sBase == 'mo_hu'
      DEFAULT lAlias TO 'MOHU'
      fl := G_Use(dir_server + 'mo_hu', {dir_server + 'mo_hu', ;
                                    dir_server + 'mo_huk', ;
                                    dir_server + 'mo_hud', ;
                                    dir_server + 'mo_huv', ;
                                    dir_server + 'mo_hua'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'mo_dnab'
      DEFAULT lAlias TO 'DN'
      fl := G_Use(dir_server + 'mo_dnab',dir_server + 'mo_dnab', lAlias, , lExcluUse, lREADONLY)
    case sBase == 'mo_hdisp'
      DEFAULT lAlias TO 'HDISP'
      fl := G_Use(dir_server + 'mo_hdisp',dir_server + 'mo_hdisp', lAlias, , lExcluUse, lREADONLY)
    case sBase == 'schet'
      DEFAULT lAlias TO 'SCHET'
      fl := G_Use(dir_server + 'schet_', ,'SCHET_', , lExcluUse, lREADONLY) .and. ;
          G_Use(dir_server + 'schet', {dir_server + 'schetk', ;
                                    dir_server + 'schetn', ;
                                    dir_server + 'schetp', ;
                                    dir_server + 'schetd'}, lAlias, , lExcluUse, lREADONLY)
      if fl
        set relation to recno() into SCHET_
      endif
    case sBase == 'kartdelz'
      fl := G_Use(dir_server + 'kartdelz',dir_server + 'kartdelz', ,, lExcluUse, lREADONLY)
    case sBase == 'kart_st'
      fl := G_Use(dir_server + 'kart_st', {dir_server + 'kart_st', ;
                                      dir_server + 'kart_st1'}, ,, lExcluUse, lREADONLY)
    case sBase == 'humanst'
      fl := G_Use(dir_server + 'humanst',dir_server + 'humanst', ,, lExcluUse, lREADONLY)
    case sBase == 'mo_pp'
      DEFAULT lAlias TO 'HU'
      fl := G_Use(dir_server + 'mo_pp', {dir_server + 'mo_pp_k', ;
                                    dir_server + 'mo_pp_d', ;
                                    dir_server + 'mo_pp_r', ;
                                    dir_server + 'mo_pp_i', ;
                                    dir_server + 'mo_pp_h'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'hum_p'
      DEFAULT lAlias TO 'HU'
      fl := G_Use(dir_server + 'hum_p', {dir_server + 'hum_pkk', ;
                                    dir_server + 'hum_pn', ;
                                    dir_server + 'hum_pd', ;
                                    dir_server + 'hum_pv', ;
                                    dir_server + 'hum_pc'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'hum_p_u'
      DEFAULT lAlias TO 'HU'
      fl := G_Use(dir_server + 'hum_p_u', {dir_server + 'hum_p_u', ;
                                      dir_server + 'hum_p_uk', ;
                                      dir_server + 'hum_p_ud', ;
                                      dir_server + 'hum_p_uv', ;
                                      dir_server + 'hum_p_ua'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'hum_ort'
      fl := G_Use(dir_server + 'hum_ort', {dir_server + 'hum_ortk', ;
                                      dir_server + 'hum_ortn', ;
                                      dir_server + 'hum_ortd', ;
                                      dir_server + 'hum_orto'},'HUMAN', , lExcluUse, lREADONLY)
    case sBase == 'hum_oru'
      fl := G_Use(dir_server + 'hum_oru', {dir_server + 'hum_oru', ;
                                      dir_server + 'hum_oruk', ;
                                      dir_server + 'hum_orud', ;
                                      dir_server + 'hum_oruv', ;
                                      dir_server + 'hum_orua'},'HU', , lExcluUse, lREADONLY)
    case sBase == 'hum_oro'
      fl := G_Use(dir_server + 'hum_oro', {dir_server + 'hum_oro', ;
                                      dir_server + 'hum_orov', ;
                                      dir_server + 'hum_orod'},'HO', , lExcluUse, lREADONLY)
    case sBase == 'kas_pl'
      fl := G_Use(dir_server + 'kas_pl', {dir_server + 'kas_pl1', ;
                                     dir_server + 'kas_pl2', ;
                                     dir_server + 'kas_pl3'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'kas_pl_u'
      fl := G_Use(dir_server + 'kas_pl_u', {dir_server + 'kas_pl1u', ;
                                       dir_server + 'kas_pl2u'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'kas_ort'
      fl := G_Use(dir_server + 'kas_ort', {dir_server + 'kas_ort1', ;
                                      dir_server + 'kas_ort2', ;
                                      dir_server + 'kas_ort3', ;
                                      dir_server + 'kas_ort4', ;
                                      dir_server + 'kas_ort5'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'kas_ortu'
      fl := G_Use(dir_server + 'kas_ortu', {dir_server + 'kas_or1u', ;
                                       dir_server + 'kas_or2u'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'mo_kekh'
      DEFAULT lAlias TO 'HU'
      fl := G_Use(dir_server + 'mo_kekh',dir_server + 'mo_kekh', lAlias, , lExcluUse, lREADONLY)
    case sBase == 'mo_keke'
      DEFAULT lAlias TO 'EKS'
      fl := G_Use(dir_server + 'mo_keke', {dir_server + 'mo_keket', ;
                                      dir_server + 'mo_kekee', ;
                                      dir_server + 'mo_keked'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'mo_kekez'
      DEFAULT lAlias TO 'EKSZ'
      fl := G_Use(dir_server + 'mo_kekez',dir_server + 'mo_kekez', lAlias, , lExcluUse, lREADONLY)
    case sBase == 'lusld'
      fl := R_Use(exe_dir+'_mo_usld',cur_dir + '_mo_usld',sBase)
  endcase
  return fl

**
Function useUch_Usl()
  return G_Use(dir_server + 'uch_usl', dir_server + 'uch_usl', 'UU') .and. ;
      G_Use(dir_server + 'uch_usl1', dir_server + 'uch_usl1', 'UU1')


** 21.01.19 �஢����, �������஢��� �� ������, �, �᫨ ���, � �������஢��� ��
Function my_Rec_Lock(n)
  if ascan(dbRLockList(), n) == 0
    G_RLock(forever)
  endif
  return NIL
  
** ������ � ���ᨢ� ������ ���� ������
Function get_field()
  Local arr := array(fcount())
  aeval(arr, {|x, i| arr[i] := fieldget(i) }  )
  return arr
  

** 04.04.18 �����஢��� ������, ��� ���� KOD == 0 (���� �������� ������)
Function Add1Rec(n, lExcluUse)
  Local fl := .t., lOldDeleted := SET(_SET_DELETED, .F.)

  DEFAULT lExcluUse TO .f.
  find (str(0, n))
  if found()
    do while kod == 0 .and. !eof()
      if iif(lExcluUse, .t., RLock())
        IF DELETED()
          RECALL
        ENDIF
        fl := .f.
        exit
      endif
      skip
    enddo
  endif
  if fl  // ���������� �����
    if lExcluUse
      APPEND BLANK
    else
      DO WHILE .t.
        APPEND BLANK
        IF !NETERR()
          exit
        ENDIF
      ENDDO
    endif
  endif
  SET(_SET_DELETED, lOldDeleted)  // ����⠭������� �।�
  return NIL

** 11.04.18 ��ࠢ������� ���筮�� 䠩�� ���� ������ �� ��ࢨ筮��
Function dbf_equalization(lAlias, lkod)
  Local fl := .t.

  dbSelectArea(lAlias)
  do while lastrec() < lkod
    do while .t.
      APPEND BLANK
      fl := .f.
      if !NETERR()
        exit
      endif
    enddo
  enddo
  if fl  // �.�. �㦭�� ������ �� �������஢��� �� ����������
    goto (lkod)
    G_RLock(forever)
  endif
  return NIL