// ��ࠢ�筨�� 䥤�ࠫ쭮�� 䮭�� ����樭᪮�� ���客���� �� ⨯� O0xx

#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'

// 05.05.22
function make_Q0xx(db, source, fOut, fError)

  make_q015(db, source, fOut, fError)
  make_q016(db, source, fOut, fError)
  make_q017(db, source, fOut, fError)

  return nil

// 20.12.22
function make_q015(db, source, fOut, fError)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local s_kod, s_name, s_nsi_obj, s_nsi_el, s_usl_test, s_val_el, s_comment, d1, d2
  local d1_1, d2_1

  // ID_TEST, �����(12), �����䨪��� �஢�ન.
  //      ��ନ����� �� 蠡���� KKKK.00.TTTT, ���
  //      KKKK - �����䨪��� ��⥣�ਨ �஢�ન 
  //        � ᮮ⢥��⢨� � �����䨪��஬ Q017,
  //      TTTT - 㭨����� ����� �஢�ન � ��⥣�ਨ
  // ID_EL, �����(100),	�����䨪��� �������, 
  //      �������饣� �஢�થ (�ਫ������ �, �����䨪��� Q018)
  // TYPE_MD	��	�����⨬� ⨯� ��।������� ������, ᮤ�ঠ�� 
  //      �������, �������騩 �஢�થ
  // TYPE_D, �����(2),	��� ��।������� ������, ᮤ�ঠ�� �������,
  //      �������騩 �஢�થ (�ਫ������ �, �����䨪��� Q019)
  // NSI_OBJ, �����(4), ��� ��ꥪ� ���, �� ᮮ⢥��⢨� � ����� 
  //      �����⢫���� �஢�ઠ ���祭�� �������
  // NSI_EL, �����(20), ��� ������� ��ꥪ� ���, �� ᮮ⢥��⢨� � 
  //      ����� �����⢫���� �஢�ઠ ���祭�� �������
  // USL_TEST, �����(254),	�᫮��� �஢������ �஢�ન �������
  // VAL_EL, �����(254),	������⢮ �����⨬�� ���祭�� �������
  // MIN_LEN, �����᫥���(4),	�������쭠� ����� ���祭�� �������
  // MAX_LEN, �����᫥���(4),	���ᨬ��쭠� ����� ���祭�� �������
  // MASK_VAL, �����(254),	��᪠ ���祭�� �������
  // COMMENT, �����(500), �������਩
  // DATEBEG, �����(10),	��� ��砫� ����⢨� �����
  // DATEEND, �����(10),	��� ����砭�� ����⢨� �����
  cmdText := 'CREATE TABLE q015( id_test TEXT(12), id_el TEXT(100), nsi_obj TEXT(4), nsi_el TEXT(20), usl_test BLOB, val_el BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'Q015.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ���祭� �孮�����᪨� �ࠢ�� ॠ����樨 ��� � �� ������� ���ᮭ���஢������ ��� ᢥ����� �� ��������� ����樭᪮� ����� (FLK_MPF)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q015') == SQLITE_OK
    fOut:add_string('DROP TABLE q015 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE q015 - Ok' + hb_eol() )
  else
    fOut:add_string('CREATE TABLE q015 - False' + hb_eol() )
    return nil
  endif
  
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q015 ( id_test, id_el, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES( :id_test, :id_el, :nsi_obj, :nsi_el, :usl_test, :val_el, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      // out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TEST')
          s_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_EL')
          s_nsi_obj := read_xml_stroke_1251_to_utf8(oXmlNode, 'NSI_OBJ')
          s_nsi_el := read_xml_stroke_1251_to_utf8(oXmlNode, 'NSI_EL')
          s_usl_test := read_xml_stroke_1251_to_utf8(oXmlNode, 'USL_TEST')
          s_val_el := read_xml_stroke_1251_to_utf8(oXmlNode, 'VAL_EL')
          s_comment :=  read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_text(stmt, 1, s_kod) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, s_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, s_nsi_obj) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, s_nsi_el) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, s_usl_test) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, s_val_el) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 7, s_comment) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 8, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 9, d2) == SQLITE_OK
            IF sqlite3_step(stmt) != SQLITE_DONE
              out_error(fError, TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif
  // out_obrabotka_eol()
  return nil

// 20.12.22
function make_q016(db, source, fOut, fError)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local s_kod, s_name, s_nsi_obj, s_nsi_el, s_usl_test, s_val_el, s_comment, d1, d2
  local d1_1, d2_1

  // ID_TEST, �����(12),	�����䨪��� �஢�ન. 
  //      ��ନ����� �� 蠡���� KKKK.RR.TTTT, ���
  //      KKKK - �����䨪��� ��⥣�ਨ �஢�ન 
  //        � ᮮ⢥��⢨� � �����䨪��஬ Q017,
  //      RR ��� ����� � ᮮ⢥��⢨� � �����䨪��஬ F010.
  //        ��� �஢�ப 䥤�ࠫ쭮�� �஢�� RR �ਭ����� ���祭�� 00.
  //      TTTT - 㭨����� ����� �஢�ન � ��⥣�ਨ
  // ID_EL, �����(100),	�����䨪��� �������, 
  //      �������饣� �஢�થ (�ਫ������ �, �����䨪��� Q018)
  
  // DESC_TEST, �����(500),	���ᠭ�� �஢�ન
  // TYPE_MD	��	�����⨬� ⨯� ��।������� ������, ᮤ�ঠ�� 
  //      �������, �������騩 �஢�થ
  // TYPE_D, �����(2),	��� ��।������� ������, ᮤ�ঠ�� �������,
  //      �������騩 �஢�થ (�ਫ������ �, �����䨪��� Q019)
  // NSI_OBJ, �����(4), ��� ��ꥪ� ���, �� ᮮ⢥��⢨� � ����� 
  //      �����⢫���� �஢�ઠ ���祭�� �������
  // NSI_EL, �����(20), ��� ������� ��ꥪ� ���, �� ᮮ⢥��⢨� � 
  //      ����� �����⢫���� �஢�ઠ ���祭�� �������
  // USL_TEST, �����(254),	�᫮��� �஢������ �஢�ન �������
  // VAL_EL, �����(254),	������⢮ �����⨬�� ���祭�� �������
  // COMMENT, �����(500), �������਩
  // DATEBEG, �����(10),	��� ��砫� ����⢨� �����
  // DATEEND, �����(10),	��� ����砭�� ����⢨� �����
  
  cmdText := 'CREATE TABLE q016( id_test TEXT(12), id_el TEXT(100), nsi_obj TEXT, nsi_el TEXT, usl_test BLOB, val_el BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'
    
  nameRef := 'Q016.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ���祭� �஢�ப ��⮬�⨧�஢����� �����প� ��� � �� ������� ���ᮭ���஢������ ��� ᢥ����� �� ��������� ����樭᪮� ����� (MEK_MPF)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q016') == SQLITE_OK
    fOut:add_string('DROP TABLE q016 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE q016 - Ok' + hb_eol())
  else
    fOut:add_string('CREATE TABLE q016 - False' + hb_eol())
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q016 ( id_test, id_el, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES( :id_test, :id_el, :nsi_obj, :nsi_el, :usl_test, :val_el, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      // out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TEST')
          s_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_EL')
          s_nsi_obj := read_xml_stroke_1251_to_utf8(oXmlNode, 'NSI_OBJ')
          s_nsi_el := read_xml_stroke_1251_to_utf8(oXmlNode, 'NSI_EL')
          s_usl_test := read_xml_stroke_1251_to_utf8(oXmlNode, 'USL_TEST')
          s_val_el := read_xml_stroke_1251_to_utf8(oXmlNode, 'VAL_EL')
          s_comment := read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_text( stmt, 1, s_kod ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_name ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_nsi_obj ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, s_nsi_el ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, s_usl_test ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 6, s_val_el ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 7, s_comment ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 8, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 9, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              out_error(fError, TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif
  // out_obrabotka_eol()
  return nil

// 20.12.22
function make_q017(db, source, fOut, fError)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local s_kod, s_name, s_comment, d1, d2, d1_1, d2_1

  // ID_KTEST, �����(4),	�����䨪��� ��⥣�ਨ �஢�ન
  // NAM_KTEST, �����(400),	������������ ��⥣�ਨ �஢�ન
  // COMMENT, �����(500), �������਩
  // DATEBEG, �����(10),	��� ��砫� ����⢨� �����
  // DATEEND, �����(10),	��� ����砭�� ����⢨� �����
  
  cmdText := 'CREATE TABLE q017( id_ktest TEXT(4), nam_ktest BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'
    
  nameRef := 'Q017.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ���祭� ��⥣�਩ �஢�ப ��� � ��� (TEST_K)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q017') == SQLITE_OK
    fOut:add_string('DROP TABLE q017 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE q017 - Ok' + hb_eol())
  else
    fOut:add_string('CREATE TABLE q017 - False' + hb_eol())
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q017 ( id_ktest, nam_ktest, comment, datebeg, dateend ) VALUES( :id_ktest, :nam_ktest, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      // out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_KTEST')
          s_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAM_KTEST')
          s_comment := read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)
          
          if sqlite3_bind_text( stmt, 1, s_kod ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_name ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_comment ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              out_error(fError, TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif
  // out_obrabotka_eol()
  return nil