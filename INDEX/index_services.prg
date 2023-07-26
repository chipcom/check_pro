#include 'function.ch'
#include 'chip_mo.ch'

// #define WORK_YEAR 2023
#define INDEX_NEED  2 // �᫮ ��� ��易⥫쭮� ��२�����樨

// 26.07.23 �஢�ઠ � ��२�����஢���� �ࠢ�筨��� �����
Function index_services(exe_dir, cur_dir, arr)
  Local buf := save_maxrow()

  dep_index_and_fill(WORK_YEAR, exe_dir, cur_dir, arr)  // �ࠢ�筨� �⤥����� �� countYear ���
  usl_Index(WORK_YEAR, exe_dir, cur_dir)    // �ࠢ�筨� ��� ����� �� countYear ���
  uslc_Index(WORK_YEAR, exe_dir, cur_dir, arr)   // 業� �� ��㣨 �� countYear ���
  uslf_Index(WORK_YEAR, exe_dir, cur_dir)   // �ࠢ�筨� ��� ����� countYear
  k006_index(WORK_YEAR, exe_dir, cur_dir)
  // unit_Index(WORK_YEAR, exe_dir, cur_dir)   // ����-�����
  // shema_index(WORK_YEAR, exe_dir, cur_dir)

  // // onkko_vmp
  // sbase := '_mo_ovmp'
  // file_index := cur_dir + sbase + sntx
  // R_Use(exe_dir + sbase )
  // index on str(metod, 3) to (cur_dir + sbase)
  // use

  // // �ࠢ�筨� ���ࠧ������� �� ��ᯮ�� ���
  // sbase := '_mo_podr'
  // file_index := cur_dir + sbase + sntx
  // R_Use(exe_dir + sbase )
  // index on codemo + padr(upper(kodotd), 25) to (cur_dir + sbase)
  // use

  rest_box(buf)

  return nil

// 26.07.23
function dep_index_and_fill(val_year, exe_dir, cur_dir, arr)
  local sbase
  local file_index
  
  sbase := prefixFileRefName(val_year) + 'dep'  // �ࠢ�筨� �⤥����� �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase, , 'DEP')
    index on str(code, 3) to (cur_dir + sbase) for codem == arr[_MO_KOD_TFOMS]

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
        R_Use(exe_dir + sbase, , 'DEP')
        index on str(code, 3) + str(pr_mp, 3) to (cur_dir + sbase) for codem == arr[_MO_KOD_TFOMS]
        use
      endif
    endif
  endif
  return nil

// 26.07.23
function usl_Index(val_year, exe_dir, cur_dir)
  local sbase
  local file_index
  local shifrVMP

  sbase := prefixFileRefName(val_year) + 'usl'  // �ࠢ�筨� ��� ����� �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase, , 'LUSL')
    index on shifr to (cur_dir + sbase)
    LUSL->(dbCloseArea())
  endif
  return nil

// 26.07.23
function uslc_Index(val_year, exe_dir, cur_dir, arr)
  local sbase, prefix
  local index_usl_name
  local file_index

  prefix := prefixFileRefName(val_year)
  sbase :=  prefix + 'uslc'  // 業� �� ��㣨 �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    index_usl_name :=  prefix + 'uslu'  // 
    file_index := cur_dir + sbase + sntx

    R_Use(exe_dir + sbase, , 'LUSLC')
    index on shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (cur_dir + sbase) ;
              for codemo == arr[_MO_KOD_TFOMS]
    index on codemo + shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (cur_dir + index_usl_name) ;
              for codemo == arr[_MO_KOD_TFOMS] // ��� ᮢ���⨬��� � ��ன ���ᨥ� �ࠢ�筨��
  
  //   if val_year == WORK_YEAR // 2020 // 2019 // 2018
  //     // ����樭᪠� ॠ������� ��⥩ � ����襭�ﬨ ��� ��� ������ �祢��� ������ ��⥬� ��嫥�୮� �������樨
  //     find (arr[_MO_KOD_TFOMS] + 'st37.015')
  //     if found()
  //       is_reabil_slux := found()
  //     endif
  
  //     find (arr[_MO_KOD_TFOMS] + '2.') // ��祡�� ����
  //     do while codemo == arr[_MO_KOD_TFOMS] .and. left(shifr, 2) == '2.' .and. !eof()
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
    
  
  //     if val_year == WORK_YEAR
  //       // find (arr[_MO_KOD_TFOMS] + '1.22.') // ��� 01.03.23
  //       find (arr[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 01.03.23
  //       is_23_VMP := found()
  //     elseif val_year == 2022
  //       // find (arr[_MO_KOD_TFOMS] + '1.21.') // ��� 11.02.22
  //       find (arr[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 11.02.22
  //       is_22_VMP := found()
  //     elseif val_year == 2021
  //       // find (arr[_MO_KOD_TFOMS] + '1.20.') // ��� 07.02.21
  //       find (arr[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 07.02.21
  //       is_21_VMP := found()
  //     elseif val_year == 2020
  //       // find (arr[_MO_KOD_TFOMS] + '1.12.') // ��� 2020 ����
  //       find (arr[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 2020 � 2019 ����
  //       is_20_VMP := found()
  //     elseif val_year == 2019
  //       // find (arr[_MO_KOD_TFOMS] + '1.12.') // ��� 2019 ����
  //       find (arr[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 2020 � 2019 ����
  //       is_19_VMP := found()
  //     // elseif val_year == 2020 .or. val_year == 2019
  //     //   // find (arr[_MO_KOD_TFOMS] + '1.12.') // ��� 2020 � 2019 ����
  //     //   find (arr[_MO_KOD_TFOMS] + code_services_VMP(val_year)) // ��� 2020 � 2019 ����
  //     //   is_12_VMP := found()
  //     endif
  //   //
  //     find (arr[_MO_KOD_TFOMS] + 'ds') // ������� ��樮���
  //     if found()
  //       if !is_napr_stac
  //         is_napr_stac := .t.
  //       endif
  //       glob_menu_mz_rf[2] := found()
  //     endif
    
  //   //
  //     tmp_stom := {'2.78.54', '2.78.55', '2.78.56', '2.78.57', '2.78.58', '2.78.59', '2.78.60'}
  //     for i := 1 to len(tmp_stom)
  //       find (arr[_MO_KOD_TFOMS] + tmp_stom[i]) //
  //       if found()
  //         glob_menu_mz_rf[3] := .t.
  //         exit
  //       endif
  //     next
    
  //   //
  //     find (arr[_MO_KOD_TFOMS] + '4.20.702') // ������⭮� �⮫����
  //     if found()
  //       aadd(glob_klin_diagn, 1)
  //     endif
  //   //
  //     find (arr[_MO_KOD_TFOMS] + '4.15.746') // �७�⠫쭮�� �ਭ����
  //     if found()
  //       aadd(glob_klin_diagn, 2)
  //     endif
  //   //
  //     find (arr[_MO_KOD_TFOMS] + '70.5.15') // �����祭�� ��砩 ��ᯠ��ਧ�樨 ��⥩-��� (0-11 ����楢), 1 �⠯ ��� ����⮫����᪨� ��᫥�������
  //     if found()
  //       glob_yes_kdp2[TIP_LU_DDS] := .t.
  //     endif
  //   //
  //     find (arr[_MO_KOD_TFOMS] + '70.6.13') // �����祭�� ��砩 ��ᯠ��ਧ�樨 ��⥩-��� (0-11 ����楢), 1 �⠯ ��� ����⮫����᪨� ��᫥�������
  //     if found()
  //       glob_yes_kdp2[TIP_LU_DDSOP] := .t.
  //     endif
  //   //
  //     find (arr[_MO_KOD_TFOMS] + '70.3.123') // �����祭�� ��砩 ��ᯠ��ਧ�樨 ���騭 (� ������ 21,24,27 ���), 1 �⠯ ��� ����⮫����᪨� ��᫥�������
  //     if found()
  //       glob_yes_kdp2[TIP_LU_DVN] := .t.
  //     endif
  //         //
  //     find (arr[_MO_KOD_TFOMS] + '72.2.41') // �����祭�� ��砩 ��䨫����᪮�� �ᬮ�� ��ᮢ��襭����⭨� (2 ���.) 1 �⠯ ��� ����⮫����᪮�� ��᫥�������
  //     if found()
  //       glob_yes_kdp2[TIP_LU_PN] := .t.
  //     endif
  
  //   endif
    LUSLC->(dbCloseArea())
  endif
  return nil

// 09.03.23
function uslf_Index(val_year, exe_dir, cur_dir)
  local sbase
  local lIndex := .f.
  local file_index
  
  sbase := prefixFileRefName(val_year) + 'uslf'  // �ࠢ�筨� ��� ����� �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase, , 'LUSLF')
    index on shifr to (cur_dir + sbase)
    use
  endif
  return nil

// 09.03.23
function unit_Index(val_year, exe_dir, cur_dir)
  local sbase
  local file_index
      
  sbase := prefixFileRefName(val_year) + 'unit'  // ����-����� �� ������� ���
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase )
    index on str(code, 3) to (cur_dir + sbase)
    use
  endif
  return nil

// 09.03.23
function shema_index(val_year, exe_dir, cur_dir)
  local sbase
  local file_index

  sbase := prefixFileRefName(val_year) + 'shema'  // 
  if hb_vfExists(exe_dir + sbase + sdbf)
    file_index := cur_dir + sbase + sntx
    R_Use(exe_dir + sbase )
    index on KOD to (cur_dir + sbase) // �� ���� �����
    use
  endif
  return nil

// 14.07.23
function k006_index(val_year, exe_dir, cur_dir)
  local sbase
  local file_index

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
// function it_Index(val_year, exe_dir, cur_dir)
//   local fl := .t.
//   local ar, ar1, ar2, lSchema, i
//   local sbase := prefixFileRefName(val_year) + 'it'  //
//   local sbaseIt1, sbaseIt, sbaseShema
//   local arrName

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
