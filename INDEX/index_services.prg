#include 'function.ch'
#include 'chip_mo.ch'

#define NUMBER_YEAR 3 // �᫮ ��� ��� ��२�����樨 �����
#define INDEX_NEED  2 // �᫮ ��� ��易⥫쭮� ��२�����樨

// 04.06.23 �஢�ઠ ������ �ࠢ�筨��� ���
function files_NSI_exists(dir_file)
  local lRet := .t.
  local i
  local sbase
  local aError := {}
  local cDbf := '.dbf'
  local cDbt := '.dbt'
  local arr_f  := {'_okator', '_okatoo', '_okatos', '_okatoo8', '_okatos8'}
  local arr_check := {}
  local countYear
  local prefix
  local arr_TFOMS
  local n_file := cur_dir + 'error_init' + stxt, sh := 80, HH := 60

  sbase := dir_file + FILE_NAME_SQL // 'chip_mo.db'
  if ! hb_FileExists(sbase)
    aadd(aError, '��������� 䠩�: ' + sbase)
  else
    if (nSize := hb_vfSize(sbase)) < 3362000
      aadd(aError, '������ 䠩�� "' + sbase + '" ����� 3362000 ����. ������� � ࠧࠡ��稪��.')
    endif
  endif

  fill_exists_files_TFOMS(dir_file)

  // �ࠢ�筨�� ���������
  sbase := dir_file + '_mo_mkb' + cDbf
  aadd(arr_check, sbase)
  sbase := dir_file + '_mo_mkbg' + cDbf
  aadd(arr_check, sbase)
  sbase := dir_file + '_mo_mkbk' + cDbf
  aadd(arr_check, sbase)

  // ��㣨 <-> ᯥ樠�쭮��
  sbase := dir_file + '_mo_spec' + cDbf
  aadd(arr_check, sbase)

  // ��㣨 <-> ��䨫�
  sbase := dir_file + '_mo_prof' + cDbf
  aadd(arr_check, sbase)

  // �ࠢ�筨� ���客�� �������� ��
  sbase := dir_file + '_mo_smo' + cDbf
  aadd(arr_check, sbase)

  // onkko_vmp
  sbase := dir_file + '_mo_ovmp' + cDbf
  aadd(arr_check, sbase)

  // N0__
  for i := 1 to 21
    sbase := dir_file + '_mo_N' + StrZero(i, 3) + cDbf
    aadd(arr_check, sbase)
  next

  // �ࠢ�筨� ���ࠧ������� �� ��ᯮ�� ���
  sbase := dir_file + '_mo_podr' + cDbf
  aadd(arr_check, sbase)

  // �ࠢ�筨� ᮮ⢥��⢨� ��䨫� ���.����� � ��䨫�� �����
  sbase := dir_file + '_mo_prprk' + cDbf
  aadd(arr_check, sbase)

  // sbase := dir_file + '_mo_t005' + cDbf
  // aadd(arr_check, sbase)
  // sbase := dir_file + '_mo_t005' + cDbt
  // aadd(arr_check, sbase)

  // sbase := dir_file + '_mo_t007' + cDbf
  // aadd(arr_check, sbase)

  // �����
  for i := 1 to len(arr_f)
    sbase := dir_file + arr_f[i] + cDbf
    aadd(arr_check, sbase)
  next

  // // for countYear = 2018 to WORK_YEAR
  //   // prefix := prefixFileRefName(countYear)
  //   // if countYear >= 2021
  //   prefix := prefixFileRefName(WORK_YEAR)
  //   if WORK_YEAR >= 2021
  //     sbase := dir_file + prefix + 'vmp_usl' + cDbf  // �ࠢ�筨� ᮮ⢥��⢨� ��� ��� ��㣠� �����
  //     aadd(arr_check, sbase)
  //   endif
  
  //   sbase := dir_file + prefix + 'dep' + cDbf  // �ࠢ�筨� �⤥����� �� ������� ���
  //   aadd(arr_check, sbase)
  //   sbase := dir_file + prefix + 'deppr' + cDbf // �ࠢ�筨� �⤥����� + ��䨫�  �� ������� ���
  //   aadd(arr_check, sbase)

  //   sbase := dir_file + prefix + 'usl' + cDbf  // �ࠢ�筨� ��� ����� �� ������� ���
  //   aadd(arr_check, sbase)

  //   sbase :=  dir_file + prefix + 'uslc' + cDbf  // 業� �� ��㣨 �� ������� ���
  //   aadd(arr_check, sbase)
  
  //   sbase := dir_file + prefix + 'uslf' + cDbf  // �ࠢ�筨� ��� ����� �� ������� ���
  //   aadd(arr_check, sbase)

  //   sbase := dir_file + prefix + 'unit' + cDbf  // ����-����� �� ������� ���
  //   aadd(arr_check, sbase)

  //   sbase := dir_file + prefix + 'shema' + cDbf  // 
  //   aadd(arr_check, sbase)

  //   sbase := dir_file + prefix + 'k006' + cDbf  // 
  //   aadd(arr_check, sbase)
  //   sbase := dir_file + prefix + 'k006' + cDbt  // 
  //   aadd(arr_check, sbase)

  // // next

  // �஢�ਬ ����⢮����� 䠩���
  for i := 1 to len(arr_check)
    if ! hb_FileExists(arr_check[i])
      aadd(aError, '��������� 䠩�: ' + arr_check[i])
    endif
  next

  prefix := dir_file + prefixFileRefName(WORK_YEAR)
  arr_TFOMS := array_exists_files_TFOMS(WORK_YEAR)
  for i := 1 to len(arr_TFOMS)
    if ! arr_TFOMS[i, 2]
      aadd(aError, '��������� 䠩�: ' + prefix + arr_TFOMS[i, 1] + cDbf)
    endif
  next

  if len(aError) > 0
    aadd(aError, '����� ����������!')
    f_message(aError, , 'GR+/R', 'W+/R', 13)
    inkey(0)

    lret := .f.
  endif

  return lRet

// 05.06.23 �஢�ઠ � ��२�����஢���� �ࠢ�筨��� �����
Function index_services(exe_dir, cur_dir, flag)
  Local fl := .t., i, arr, buf := save_maxrow()
  local arrRefFFOMS := {}, row, row_flag := .t.
  local lSchema := .f.
  local countYear
  local file_index, sbase
  local nSize
  local cVar

  DEFAULT flag TO .f.


  if flag
    // for countYear = WORK_YEAR - 4 to WORK_YEAR
    // for countYear = WORK_YEAR - NUMBER_YEAR to WORK_YEAR
    for countYear = 2018 to WORK_YEAR
      fl := dep_index_and_fill(countYear, exe_dir, cur_dir, flag)  // �ࠢ�筨� �⤥����� �� countYear ���
      fl := usl_Index(countYear, exe_dir, cur_dir, flag)    // �ࠢ�筨� ��� ����� �� countYear ���
      fl := uslc_Index(countYear, exe_dir, cur_dir, flag)   // 業� �� ��㣨 �� countYear ���
      fl := uslf_Index(countYear, exe_dir, cur_dir, flag)   // �ࠢ�筨� ��� ����� countYear
      fl := unit_Index(countYear, exe_dir, cur_dir, flag)   // ����-�����
      fl := shema_index(countYear, exe_dir, cur_dir, flag)
      fl := k006_index(countYear, exe_dir, cur_dir, flag)
      // fl := it_Index(countYear, exe_dir, cur_dir, flag)
    next
  else
    fl := dep_index_and_fill(WORK_YEAR, exe_dir, cur_dir, flag)  // �ࠢ�筨� �⤥����� �� countYear ���
    fl := usl_Index(WORK_YEAR, exe_dir, cur_dir, flag)    // �ࠢ�筨� ��� ����� �� countYear ���
    fl := uslc_Index(WORK_YEAR, exe_dir, cur_dir, flag)   // 業� �� ��㣨 �� countYear ���
    fl := uslf_Index(WORK_YEAR, exe_dir, cur_dir, flag)   // �ࠢ�筨� ��� ����� countYear
    fl := unit_Index(WORK_YEAR, exe_dir, cur_dir, flag)   // ����-�����
    fl := shema_index(WORK_YEAR, exe_dir, cur_dir, flag)
    fl := k006_index(WORK_YEAR, exe_dir, cur_dir, flag)
    // fl := it_Index(WORK_YEAR, exe_dir, cur_dir, flag)
  endif

  for i := 2019 to WORK_YEAR
    cVar := 'is_' + substr(str(i, 4), 3) + '_VMP'
    is_MO_VMP := is_MO_VMP .or. __mvGet( cVar )
  next

  // onkko_vmp
  sbase := '_mo_ovmp'
  file_index := cur_dir + sbase + sntx
  R_Use(exe_dir + sbase )
  index on str(metod, 3) to (cur_dir + sbase)
  use

  // �ࠢ�筨� ���ࠧ������� �� ��ᯮ�� ���
  sbase := '_mo_podr'
  file_index := cur_dir + sbase + sntx
  R_Use(exe_dir + sbase )
  index on codemo + padr(upper(kodotd), 25) to (cur_dir + sbase)
  use

  close databases
  rest_box(buf)

  return nil

// 09.03.23
function dep_index_and_fill(val_year, exe_dir, cur_dir, flag)
  local sbase
  local file_index
  
  DEFAULT flag TO .f.
  // is_otd_dep, glob_otd_dep, mm_otd_dep - ������ ࠭�� ��� Public
  sbase := prefixFileRefName(val_year) + 'dep'  // �ࠢ�筨� �⤥����� �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase, , 'DEP')
    index on str(code, 3) to (cur_dir + sbase) for codem == glob_mo[_MO_KOD_TFOMS]

    if val_year == WORK_YEAR
      dbeval({|| aadd(mm_otd_dep, {alltrim(dep->name_short) + ' (' + alltrim(dep->name) + ')', dep->code, dep->place})})
      if (is_otd_dep := (len(mm_otd_dep) > 0))
        asort(mm_otd_dep, , , {|x, y| x[1] < y[1]})
      endif
    endif
    use
    if is_otd_dep
      lIndex := .f.
      sbase := prefixFileRefName(val_year) + 'deppr' // �ࠢ�筨� �⤥����� + ��䨫�  �� ������� ���
      if hb_vfExists(exe_dir + sbase + sdbf)
        file_index := cur_dir + sbase + sntx
        // if (year(sys_date) - val_year) < INDEX_NEED
        //   lIndex := .t.
        // endif
        // if ! hb_FileExists(file_index)
        //   lIndex := .t.
        // endif
        // if lIndex
          R_Use(exe_dir + sbase, , 'DEP')
          index on str(code, 3) + str(pr_mp, 3) to (cur_dir + sbase) for codem == glob_mo[_MO_KOD_TFOMS]
          use
        // endif
      endif
    endif
  endif
  return nil

// 14.03.23
function usl_Index(val_year, exe_dir, cur_dir, flag)
  local sbase
  local file_index
  local shifrVMP

  DEFAULT flag TO .f.
  sbase := prefixFileRefName(val_year) + 'usl'  // �ࠢ�筨� ��� ����� �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase, ,'LUSL')
    index on shifr to (cur_dir + sbase)
    if val_year == WORK_YEAR
      shifrVMP := code_services_VMP(WORK_YEAR)
      find (shifrVMP)
      // find ('1.22.') // ��� 䥤�ࠫ쭮�   // 01.03.23 ������ ��� � 1.21 �� 1.22 ���쬮
      // find ('1.21.') // ��� 䥤�ࠫ쭮�   // 10.02.22 ������ ��� � 1.20 �� 1.21 ���쬮 12-20-60 �� 01.02.22
      // find ('1.20.') // ��� 䥤�ࠫ쭮�   // 07.02.21 ������ ��� � 1.12 �� 1.20 ���쬮 12-20-60 �� 01.02.21
      // do while left(lusl->shifr,5) == '1.20.' .and. !eof()
      // do while left(lusl->shifr,5) == '1.21.' .and. !eof()
      // do while left(lusl->shifr, 5) == '1.22.' .and. !eof()
      do while left(lusl->shifr, 5) == shifrVMP .and. !eof()
        aadd(arr_12_VMP, int(val(substr(lusl->shifr, 6))))
        skip
      enddo
    endif
    close databases
  endif
  return nil

// 23.03.23
function uslc_Index(val_year, exe_dir, cur_dir, flag)
  local sbase, prefix
  local index_usl_name
  local file_index
  
  DEFAULT flag TO .f.
  prefix := prefixFileRefName(val_year)
  sbase :=  prefix + 'uslc'  // 業� �� ��㣨 �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    index_usl_name :=  prefix + 'uslu'  // 
    file_index := cur_dir + sbase + sntx

    R_Use(exe_dir + sbase, , 'LUSLC')
    index on shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (cur_dir + sbase) ;
              for codemo == glob_mo[_MO_KOD_TFOMS]
    index on codemo + shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (cur_dir + index_usl_name) ;
              for codemo == glob_mo[_MO_KOD_TFOMS] // ��� ᮢ���⨬��� � ��ன ���ᨥ� �ࠢ�筨��
  
  //   if val_year == WORK_YEAR // 2020 // 2019 // 2018
  //     // ����樭᪠� ॠ������� ��⥩ � ����襭�ﬨ ��� ��� ������ �祢��� ������ ��⥬� ��嫥�୮� �������樨
  //     find (glob_mo[_MO_KOD_TFOMS] + 'st37.015')
  //     if found()
  //       is_reabil_slux := found()
  //     endif
  
  //     find (glob_mo[_MO_KOD_TFOMS] + '2.') // ��祡�� ����
  //     do while codemo == glob_mo[_MO_KOD_TFOMS] .and. left(shifr, 2) == '2.' .and. !eof()
  //       if left(shifr, 5) == '2.82.'
  //         is_vr_pr_pp := .t. // ��祡�� �ਥ� � ��񬭮� �⤥����� ��樮���
  //         if is_napr_pol
  //           exit
  //         endif
  //       else
  //         is_napr_pol := .t.
  //         if is_vr_pr_pp
  //           exit
  //         endif
  //       endif
  //       skip
  //     enddo
    
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + '60.3.')
  //     if found()
  //       is_alldializ := .t.
  //     endif
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + '60.3.1')
  //     if found()
  //       is_per_dializ := .t.
  //     endif
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + '60.3.9')
  //     if found()
  //       is_hemodializ := .t.
  //     else
  //       find (glob_mo[_MO_KOD_TFOMS] + '60.3.10')
  //       if found()
  //         is_hemodializ := .t.
  //       endif
  //     endif
  
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + 'st') // �����-���
  //     if (is_napr_stac := found())
  //       glob_menu_mz_rf[1] := .t.
  //     endif
  //   //
  //     if val_year == WORK_YEAR
  //       // find (glob_mo[_MO_KOD_TFOMS] + '1.22.') // ��� 01.03.23
  //       find (glob_mo[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 01.03.23
  //       is_23_VMP := found()
  //     elseif val_year == 2022
  //       // find (glob_mo[_MO_KOD_TFOMS] + '1.21.') // ��� 11.02.22
  //       find (glob_mo[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 11.02.22
  //       is_22_VMP := found()
  //     elseif val_year == 2021
  //       // find (glob_mo[_MO_KOD_TFOMS] + '1.20.') // ��� 07.02.21
  //       find (glob_mo[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 07.02.21
  //       is_21_VMP := found()
  //     elseif val_year == 2020
  //       // find (glob_mo[_MO_KOD_TFOMS] + '1.12.') // ��� 2020 ����
  //       find (glob_mo[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 2020 � 2019 ����
  //       is_20_VMP := found()
  //     elseif val_year == 2019
  //       // find (glob_mo[_MO_KOD_TFOMS] + '1.12.') // ��� 2019 ����
  //       find (glob_mo[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 2020 � 2019 ����
  //       is_19_VMP := found()
  //     // elseif val_year == 2020 .or. val_year == 2019
  //     //   // find (glob_mo[_MO_KOD_TFOMS] + '1.12.') // ��� 2020 � 2019 ����
  //     //   find (glob_mo[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 2020 � 2019 ����
  //     //   is_12_VMP := found()
  //     endif
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + 'ds') // ������� ��樮���
  //     if found()
  //       if !is_napr_stac
  //         is_napr_stac := .t.
  //       endif
  //       glob_menu_mz_rf[2] := found()
  //     endif
    
  //   //
  //     tmp_stom := {'2.78.54', '2.78.55', '2.78.56', '2.78.57', '2.78.58', '2.78.59', '2.78.60'}
  //     for i := 1 to len(tmp_stom)
  //       find (glob_mo[_MO_KOD_TFOMS] + tmp_stom[i]) //
  //       if found()
  //         glob_menu_mz_rf[3] := .t.
  //         exit
  //       endif
  //     next
    
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + '4.20.702') // ������⭮� �⮫����
  //     if found()
  //       aadd(glob_klin_diagn, 1)
  //     endif
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + '4.15.746') // �७�⠫쭮�� �ਭ����
  //     if found()
  //       aadd(glob_klin_diagn, 2)
  //     endif
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + '70.5.15') // �����祭�� ��砩 ��ᯠ��ਧ�樨 ��⥩-��� (0-11 ����楢), 1 �⠯ ��� ����⮫����᪨� ��᫥�������
  //     if found()
  //       glob_yes_kdp2[TIP_LU_DDS] := .t.
  //     endif
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + '70.6.13') // �����祭�� ��砩 ��ᯠ��ਧ�樨 ��⥩-��� (0-11 ����楢), 1 �⠯ ��� ����⮫����᪨� ��᫥�������
  //     if found()
  //       glob_yes_kdp2[TIP_LU_DDSOP] := .t.
  //     endif
  //   //
  //     find (glob_mo[_MO_KOD_TFOMS] + '70.3.123') // �����祭�� ��砩 ��ᯠ��ਧ�樨 ���騭 (� ������ 21,24,27 ���), 1 �⠯ ��� ����⮫����᪨� ��᫥�������
  //     if found()
  //       glob_yes_kdp2[TIP_LU_DVN] := .t.
  //     endif
  //         //
  //     find (glob_mo[_MO_KOD_TFOMS] + '72.2.41') // �����祭�� ��砩 ��䨫����᪮�� �ᬮ�� ��ᮢ��襭����⭨� (2 ���.) 1 �⠯ ��� ����⮫����᪮�� ��᫥�������
  //     if found()
  //       glob_yes_kdp2[TIP_LU_PN] := .t.
  //     endif
  
  //   endif
    close databases
  endif
  return nil

// 09.03.23
function uslf_Index(val_year, exe_dir, cur_dir, flag)
  local sbase
  local lIndex := .f.
  local file_index
  
  DEFAULT flag TO .f.
  sbase := prefixFileRefName(val_year) + 'uslf'  // �ࠢ�筨� ��� ����� �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase, , 'LUSLF')
    index on shifr to (cur_dir + sbase)
    use
  endif
  return nil

// 09.03.23
function unit_Index(val_year, exe_dir, cur_dir, flag)
  local sbase
  local file_index
      
  DEFAULT flag TO .f.
  sbase := prefixFileRefName(val_year) + 'unit'  // ����-����� �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase )
    index on str(code, 3) to (cur_dir + sbase)
    use
  endif
  return nil

// 09.03.23
function shema_index(val_year, exe_dir, cur_dir, flag)
  local sbase
  local file_index

  DEFAULT flag TO .f.
  sbase := prefixFileRefName(val_year) + 'shema'  // 
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase )
    index on KOD to (cur_dir + sbase) // �� ���� �����
    use
  endif
  return nil

// 14.07.23
function k006_index(val_year, exe_dir, cur_dir, flag)
  local sbase
  local file_index

  DEFAULT flag TO .f.

  sbase := prefixFileRefName(val_year) + 'k006'  // 
  if hb_vfExists(exe_dir + sbase + sdbf) .and. hb_vfExists(exe_dir + sbase + sdbt)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase)
    index on substr(shifr, 1, 2) + ds + sy + age + sex + los to (cur_dir + sbase) // �� ��������/����樨
    index on substr(shifr, 1, 2) + sy + ds + age + sex + los to (cur_dir + sbase + '_') // �� ����樨/��������
    index on ad_cr to (cur_dir + sbase + 'AD') // �� �������⥫쭮�� ����� ������
    use
  endif
  return nil
  
// 29.01.22
// function it_Index(val_year, exe_dir, cur_dir, flag)
//   local fl := .t.
//   local ar, ar1, ar2, lSchema, i
//   local sbase := prefixFileRefName(val_year) + 'it'  //
//   local sbaseIt1, sbaseIt, sbaseShema
//   local arrName

  // DEFAULT flag TO .f.
//   if val_year < 2018 .or. val_year > WORK_YEAR // ���� �� �室�� � ࠡ�稩 ��������
//     return fl
//   endif

//   sbaseIt := prefixFileRefName(val_year) + 'it'
//   sbaseIt1 := prefixFileRefName(val_year) + 'it1'
//   sbaseShema := prefixFileRefName(val_year) + 'shema'

//   if val_year == 2018
//     arrName := 'arr_ad_cr_it'
//   else
//     arrName := 'arr_ad_cr_it' + last_digits_year(val_year)
//   endif
//   Public &arrName := {}

//   if val_year >= 2021 // == WORK_YEAR

//     // ��室�� 䠩� T006 22 ����
//     if hb_FileExists(exe_dir + sbaseIt1 + sdbf)
//       R_Use(exe_dir + sbaseShema, , 'SCHEMA')
//       index on KOD to (cur_dir + sbaseShema)
  
//       R_Use(exe_dir + sbaseIt1, ,'IT1')
//       ('IT1')->(dbGoTop())  // go top
//       do while !('IT1')->(eof())
//         ar := {}
//         ar1 := {}
//         ar2 := {}
//         if !empty(it1->ds)
//           ar := Slist2arr(it1->ds)
//           for i := 1 to len(ar)
//             ar[i] := padr(ar[i], 5)
//           next
//         endif
//         if !empty(it1->ds1)
//           ar1 := Slist2arr(it1->ds1)
//           for i := 1 to len(ar1)
//             ar1[i] := padr(ar1[i], 5)
//           next
//         endif
//         if !empty(it1->ds2)
//           ar2 := Slist2arr(it1->ds2)
//           for i := 1 to len(ar2)
//             ar2[i] := padr(ar2[i], 5)
//           next
//         endif
  
//         ('SCHEMA')->(dbGoTop())
//         if ('SCHEMA')->(dbSeek( padr(it1->CODE, 6)))
//           lSchema := .t.
//         endif

//         if lSchema
//           aadd(&arrName, {it1->USL_OK, padr(it1->CODE, 6), ar, ar1, ar2, alltrim(SCHEMA->NAME)})
//         else
//           aadd(&arrName, {it1->USL_OK, padr(it1->CODE, 6), ar, ar1, ar2, ''})
//         endif
//         ('IT1')->(dbskip()) 
//         lSchema := .f.
//       enddo
//       ('SCHEMA')->(dbCloseArea())
//       ('IT1')->(dbCloseArea())   //use
//     else
//       fl := notExistsFileNSI( exe_dir + sbaseIt1 + sdbf )
//     endif
//   elseif val_year == 2020
//     // ��室�� 䠩�  T006 2020 ����
//     if hb_FileExists(exe_dir + sbaseIt1 + sdbf)
//       R_Use(exe_dir + sbaseIt1, , 'IT')
//       go top
//       do while !eof()
//         ar := {}
//         ar1 := {}
//         ar2 := {}
//         if !empty(it->ds)
//           ar := Slist2arr(it->ds)
//           for i := 1 to len(ar)
//             ar[i] := padr(ar[i], 5)
//           next
//         endif
//         if !empty(it->ds1)
//           ar1 := Slist2arr(it->ds1)
//           for i := 1 to len(ar1)
//             ar1[i] := padr(ar1[i], 5)
//           next
//         endif
//         if !empty(it->ds2)
//           ar2 := Slist2arr(it->ds2)
//           for i := 1 to len(ar2)
//             ar2[i] := padr(ar2[i], 5)
//           next
//         endif
//         aadd(&arrName, {it->USL_OK, padr(it->CODE, 3), ar, ar1, ar2})
//         skip
//       enddo
//       use
//     else
//       fl := notExistsFileNSI( exe_dir + sbaseIt1 + sdbf )
//     endif
//   elseif val_year == 2019
//     // ��室�� 䠩�  T006 2019 ���
//     sbase := '_mo9it'
//     if hb_FileExists(exe_dir + sbaseIt + sdbf)
//       R_Use(exe_dir + sbaseIt, ,'IT')
//       index on ds to tmpit memory
//       dbeval({|| aadd(arr_ad_cr_it19, {it->ds, it->it}) })
//       use
//     else
//       fl := notExistsFileNSI( exe_dir + sbaseIt + sdbf )
//     endif
//   elseif val_year == 2018
//     if hb_FileExists(exe_dir + sbaseIt + sdbf)
//       R_Use(exe_dir + sbaseIt, , 'IT')
//       index on ds to tmpit memory
//       dbeval({|| aadd(arr_ad_cr_it, {it->ds, it->it}) })
//       use
//     else
//       fl := notExistsFileNSI( exe_dir + sbaseIt + sdbf )
//     endif
//   endif
//   return fl
