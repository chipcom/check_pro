/* �ணࠬ�� �������樨 XML-�ࠢ�筨��� ����� � "���᪨�" DBF-䠩��
   S_Subdiv.xml - ᯨ᮪ 11 ��०����� � ࠧ�묨 �஢�ﬨ ������
   S_Dep.xml    - ᯨ᮪ �⤥����� �� 11-� ��樮��ࠬ � ࠧ�묨 �஢�ﬨ ������
   SPRMU.xml    - �ࠢ�筨� ��� /������������, ��� ��㣨
   S_MOServ.xml - ���� ����⢨� ��㣨 �����
   S_Prices.xml - 業� � ��� ����⢨� �� �஢��
   S_LvlPay.xml - ��� �� � �஢��� ���
   SPRDS.xml    - 䥤�ࠫ�� �ࠢ�筨� ���
   SPRUNIT.xml  - �ࠢ�筨� ����� ����� /����-�����
   S_kiro.xml   - ��� ��� - ����
   SPRKSLP.xml  - ��� ��� - ����
   T006.xml     - ���

   _mo3usl    - _mo_usl  - �ࠢ�筨� ������������ ��� ���
   _mo3uslc   - _mo_uslc - �ࠢ�筨� ��� � 業��� ��� �������� ��
                           ��� ���

  _mo_t2_v1   - �ࠢ�筨� ᮮ⢥�ᢨ� ��� ����� ��㣠� �� ��
*/

//#include 'dict_error.ch'

#include 'inkey.ch'
#include 'fileio.ch'
#include 'directry.ch'
#include 'edit_spr.ch'
#include 'function.ch'
#include 'tfile.ch'
#include '.\dict_error.ch'

// 18.08.23
// ������ ��䨪� �ࠢ�筮�� 䠩�� ��� ����
function prefixFileNameForYear(work_year)
  return '_mo' + substr(work_year, 4, 1)

// 20.08.23
function run_tfomsimport()
  // Local _mo_usl := { ;
  //   {'SHIFR',      'C',     10,      0}, ;
  //   {'NAME',       'C',    255,      0}, ;
  //   {'ST',         'N',      1,      0}, ;
  //   {'USL_OK',     'N',      1,      0}, ;
  //   {'USL_OKS',    'C',      4,      0}, ;
  //   {'UNIT_CODE',  'N',      3,      0}, ; // ���� -���� - �����
  //   {'UNITS',      'C',     16,      0}, ; // ���� -���� - �����
  //   {'BUKVA',      'C',     10,      0}, ; // �㪢� ⨯� ���
  //   {'VMP_F',      'C',      2,      0}, ;
  //   {'VMP_S',      'C',      8,      0}, ;
  //   {'IDSP',       'C',      2,      0}, ;
  //   {'IDSPS',      'C',      8,      0}, ;
  //   {'KSLP',       'N',      2,      0}, ;
  //   {'KSLPS',      'C',     10,      0}, ;
  //   {'KIRO',       'N',      2,      0}, ;
  //   {'KIROS',      'C',     10,      0}, ;
  //   {'UETV',       'N',      5,      2}, ; // ��� - ᥩ�� �� �ᯮ�������
  //   {'UETD',       'N',      5,      2}, ; // ��� - ᥩ�� �� �ᯮ�������
  //   {'DATEBEG',    'D',      8,      0}, ; // ��� ��砫� ����⢨� - �� 㬮�砭�� �.�
  //   {'DATEEND',    'D',      8,      0} ;  // ��� ����� ����⢨� - �� 㬮�砭�� �.�
  // }

  local nameFileUsl   //:= prefixFileNameForYear() + 'usl'
  local nameFileUslC  // := prefixFileNameForYear() + 'uslc'
  local nameFileIt    // := prefixFileNameForYear() + 'it'
  local nameFileK006  // := prefixFileNameForYear() + 'k006'

  local k006dbf       // := nameFileK006 + '.dbf'
  local k006dbt       // := nameFileK006 + '.dbt'
  local nResult

  local source
  local destination
  local os_sep := hb_osPathSeparator()
  // local fp
  local i, s
  local t1, t2
  local fError, nSizeError
  local fOut, nSizeOut
  local ar
  local group_ini := 'CONVERT_FILES'
  local work_year


  // Public sys_date := date() // ctod('31/12/2021') //date()
  // Public sys_year := year(date()) // 2021 // year(date())

  t1 := seconds()

  ar := GetIniSect(get_app_ini(), group_ini)
  source := a2default(ar, 'source_path', '')
  destination := a2default(ar, 'destination_path', '')
  work_year := a2default(ar, 'work_year', '2023')

  nameFileUsl := prefixFileNameForYear(work_year) + 'usl'
  nameFileUslC := prefixFileNameForYear(work_year) + 'uslc'
  nameFileIt := prefixFileNameForYear(work_year) + 'it'
  nameFileK006 := prefixFileNameForYear(work_year) + 'k006'

  k006dbf := nameFileK006 + '.dbf'
  k006dbt := nameFileK006 + '.dbt'

  fError := TFileText():New(cur_dir() + 'error.log', , .t., , .t.)
  fOut := TFileText():New(cur_dir() + 'output.log', , .t., , .t.)

  if right(source, 1) != os_sep
    source += os_sep
  endif
  if right(destination, 1) != os_sep
    destination += os_sep
  endif
  
  if !(hb_vfDirExists( source ))
    out_error(DIR_IN_NOT_EXIST, source)
    quit
  endi

  if !(hb_vfDirExists( destination ))
    out_error(DIR_OUT_NOT_EXIST, destination)
    quit
  endi

  // //// make_uslugi_mz(source, destination, fOut, fError, work_year)  // ��ࠢ�筨� �����ࠢ� ��� �ନ஢���� 䠩��� �����
  // // ��ࠢ�筨�� �����
  // dbcreate(destination + nameFileUsl, _mo_usl)
  work_Shema(source, destination, fOut, fError, work_year)
  work_SprSubDiv(source, destination, fOut, fError, work_year)
  work_SprDep(source, destination, fOut, fError, work_year)
  work_LvlPay(source, destination, fOut, fError, work_year)
  work_MOServ(source, destination, fOut, fError, work_year)
  work_Prices(source, destination, fOut, fError, work_year)
  work_mo_uslf(source, destination, fOut, fError, work_year)
  work_SprUnit(source, destination, fOut, fError, work_year)
  work_SprKslp(source, destination, fOut, fError, work_year)
  work_SprKiro(source, destination, fOut, fError, work_year)
  work_SprMU(source, destination, fOut, fError, work_year)
  work_SprDS(source, destination, fOut, fError, work_year)
  work_t006(source, destination, fOut, fError, work_year)
  close databases
  //
  HB_VFERASE(destination + k006dbf)
  nResult := FRename(destination + 't006_2.dbf', destination + k006dbf)
  if nResult != 0
    out_error(FILE_RENAME_ERROR, 't006_2.dbf')
  endif

  HB_VFERASE(destination + k006dbt)
  nResult := FRename(destination + 't006_2.dbt', destination + k006dbt)
  if nResult != 0
    out_error(FILE_RENAME_ERROR, 't006_2.dbt')
  endif
  if upper(source) != upper(destination)
    // filecopy(source + 'onko_napr' + '.dbf', destination + 'onko_napr' + '.dbf')
    // filecopy(source + 'onko_ksg' + '.dbf', destination + 'onko_ksg' + '.dbf')
    // filecopy(source + 'telemed' + '.dbf', destination + 'telemed' + '.dbf')
    filecopy(source + 'par_org' + '.dbf', destination + 'par_org' + '.dbf')
  endif

  //
  dbcreate(destination + nameFileIt, { {'ds', 'C', 5, 0}, {'it', 'N', 1, 0} } )

  use (destination + nameFileIt) new alias IT
  index on ds+str(it, 1) to tmp_it

  use (destination + nameFileK006) new alias K6
  index on ds to tmp_k6 for lower(left(ad_cr, 2)) == 'it'
  go top
  do while !eof()
    lit := int(val(substr(ltrim(k6->ad_cr), 3, 1)))
    select IT
    find (padr(k6->ds, 5) + str(lit, 1))
    if !found()
      append blank
      replace ds with k6->ds, it with lit
    endif
    select K6
    skip
  enddo
  close databases

  // ������� ������������ ���
  use (destination + nameFileUsl) new alias LUSL
  index on shifr to tmp_lusl

  use (destination + 't006_u') new alias T006
  index on fsort_usl(shifr) to tmp6
  go top
  do while !eof()
    ar := get_field()
    select LUSL
    find (t006->shifr)
    if found()
    endif
    append blank
    aeval(ar, {|x, i| fieldput(i, x) } )
    //
    // ���������
    //
    if left(t006->shifr, 2) == 'st'
      lusl->idsp := lusl->idsps := '33' // ��� � ��樮���
      lusl->unit_code := 29
      lusl->units := '29'  // ��砩 ��ᯨ⠫���樨
      if left(t006->shifr, 5) == 'st37.'
        lusl->unit_code := 142
        lusl->units := '142' // ��砩 ��ᯨ⠫���樨 �� ॠ�����樨
      endif
    elseif alltrim(t006->shifr) == 'ds18.002' // ���.�࠯�� � ��樥�⮢ �� �������
      lusl->idsp := lusl->idsps := '33' // ��� � ������� ��樮��� ????
      lusl->unit_code := 259
      lusl->units := '259' // ��砩 �������
    else
      lusl->idsp := lusl->idsps := '33' // ��� � ������� ��樮���
      lusl->unit_code := 143
      lusl->units := '143' // ��砩 ��祭��
      if left(t006->shifr, 5) == 'ds37.'
        // ॠ������� � ������� ��樮���
      endif
    endif
    select T006
    skip
  enddo
  close databases
  //
  work_uslc(source, destination, fOut, fError, work_year)
  close databases
  //
  aup := {}
  use (destination + '_mo_prof') new alias PROF
  index on fsort_usl(shifr) to tmp_prof
  go top
  do while !eof()
    if (j := ascan(aup, {|x| x[1]==prof->shifr .and. x[2] == prof->VZROS_REB})) == 0
      aadd(aup,{prof->shifr, prof->VZROS_REB, {}})
      j := len(aup)
    endif
    if ascan(aup[j, 3], prof->PROFIL) == 0
      aadd(aup[j, 3], prof->PROFIL)
    endif
    skip
  enddo
  //
  aup := {}
  use (destination + '_mo_spec') new alias SPEC
  index on fsort_usl(shifr) to tmp_spec
  go top
  do while !eof()
    if (j := ascan(aup, {|x| x[1] == spec->shifr .and. x[2] == spec->VZROS_REB})) == 0
      aadd(aup, {spec->shifr, spec->VZROS_REB, {}})
      j := len(aup)
    endif
    if ascan(aup[j, 3], spec->PRVS_NEW) == 0
      aadd(aup[j, 3], spec->PRVS_NEW)
    endif
    skip
  enddo
  // fclose(fp)
  close databases
  HB_VFERASE(cur_dir() + 'tmp*.dbf')
  HB_VFERASE(cur_dir() + 'tmp*.ntx')
  HB_VFERASE(cur_dir() + 'tmp_it.ntx')
  HB_VFERASE(cur_dir() + 'tmp_k6.ntx')
  HB_VFERASE(cur_dir() + 'tmp_lusl.ntx')
  HB_VFERASE(cur_dir() + 'tmp_lvlpay.ntx')
  HB_VFERASE(cur_dir() + 'tmp_ok.ntx')
  HB_VFERASE(cur_dir() + 'tmp_on.ntx')
  HB_VFERASE(cur_dir() + 'tmp_po.ntx')
  HB_VFERASE(cur_dir() + 'tmp_prices.ntx')
  HB_VFERASE(cur_dir() + 'tmp_prof.ntx')
  HB_VFERASE(cur_dir() + 'tmp_shema.ntx')
  HB_VFERASE(cur_dir() + 'tmp_spec.ntx')
  HB_VFERASE(cur_dir() + 'tmp_tel.ntx')
  HB_VFERASE(cur_dir() + 'tmp_unit.ntx')
  HB_VFERASE(cur_dir() + 'tmp_usl.ntx')
  HB_VFERASE(cur_dir() + 'tmp1.ntx')
  HB_VFERASE(cur_dir() + 'tmp6.ntx')
  // HB_VFERASE(cur_dir() + 'not_lev.ntx')
  // HB_VFERASE(cur_dir() + 'not_usl.ntx')
  
  HB_VFERASE(destination + 't006_2.dbf')
  HB_VFERASE(destination + 't006_2.dbt')
  HB_VFERASE(destination + 't006_d.dbf')
  HB_VFERASE(destination + 't006_u.dbf')

  t2 := seconds() - t1

  if t2 > 0
    fOut:add_string('�६� �������樨 - ' + sectotime(t2) + hb_eol())
  endif

  nSizeError := fError:Size()
  nSizeOut := fOut:Size()
  fError := nil
  fOut := nil

  if nSizeError > 0
    viewtext(cur_dir() + 'error.log', , , , .t., , , 2)
  endif
  if nSizeOut > 0
    viewtext(cur_dir() + 'output.log', , , , .t., , , 2)
  endif

  return nil

// 11.02.22
function obrabotka(nfile)

  @ row() + 1, 1 say '��ࠡ�⪠ 䠩�� ' + nfile + ' -'
  return Col()

// 13.02.22
function out_obrabotka(nfile)

  OutStd('===== ��ࠡ�⪠ 䠩�� ' + nfile )
  return nil

// 15.02.22
function out_create_file(nfile)

  OutStd('�������� 䠩�� ' + nfile )
  return nil

// 14.02.22
function out_obrabotka_eol()

  OutStd(hb_eol())
  return nil

// 14.02.22
function out_obrabotka_count(j, k)

  // OutStd( str(j / k * 100, 6, 2) + '%' )
  return nil

// // 15.02.22
// function out_error(nError, nfile, j, k)

//   DO CASE
//   CASE nError == FILE_NOT_EXIST
//     OutErr('���� ' + nfile + ' �� �������', hb_eol())
//   CASE nError == FILE_READ_ERROR
//     OutErr('�訡�� � ����㧪� 䠩�� ' + nfile, hb_eol())
//   CASE nError == FILE_RENAME_ERROR
//     OutErr('�訡�� ��२��������� 䠩�� ' + nfile, hb_eol())
//   CASE nError == DIR_IN_NOT_EXIST
//     OutErr('��⠫�� ��室��� ������ "' + nfile + '" �� �������. �த������� ࠡ��� �� ��������!', hb_eol())
//   CASE nError == DIR_OUT_NOT_EXIST
//     OutErr('��⠫�� ��� ��室��� ������ "' + nfile + '" �� �������. �த������� ࠡ��� �� ��������!', hb_eol())
//   CASE nError == TAG_YEAR_REPORT
//       OutErr('�訡�� �� �⥭�� 䠩�� "' + nfile + '". �����४⭮� ���祭�� ⥣� YEAR_REPORT ', j, hb_eol())
//   CASE nError == TAG_PLACE_ERROR
//       OutErr('�訡�� �� �⥭�� 䠩�� "' + nfile + '" - ����� ������ ⥣� PLACE � �⤥�����: ', alltrim(j), hb_eol())
//   CASE nError == TAG_PERIOD_ERROR
//       OutErr('�訡�� �� �⥭�� 䠩�� "' + nfile + '" - ����� ������ ⥣� PERIOD � ��०�����: ', j, ' � ��㣥 ', k, hb_eol())
//   CASE nError == TAG_VALUE_EMPTY
//       OutErr('����砭�� �� �⥭�� 䠩�� "' + nfile + '" - ���⮥ ���祭�� ⥣� VALUE/LEVEL: ', j, ' � ��㣥 ', k, hb_eol())
//   CASE nError == TAG_VALUE_INVALID
//       OutErr('����砭�� �� �⥭�� 䠩�� "' + nfile + '" - �����४⭮� ���祭�� ⥣� VALUE/LEVEL: ', j, ' � ��㣥 ', k, hb_eol())
//   end case

//   return nil