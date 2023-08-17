/// ��ࠢ�筨�� �����
#include "dict_error.ch"

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

***** 11.02.22
Function work_V002(source, destination)
  local _mo_V002 := {;
    {"IDPR",       "N",      3,      0},;
    {"PRNAME",     "C",    250,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nfile, nameRef

  nameRef := "V002.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  dbcreate(destination + "_mo_v002", _mo_V002)
  use (destination + '_mo_V002') new alias V002
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� ��䨫�� ��������� ����樭᪮� ����� (ProfOt)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)         
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mDATEEND := CToD('  /  /    ')
        mIDPR := mo_read_xml_stroke(oXmlNode,"IDPR",)
        mPRNAME := mo_read_xml_stroke(oXmlNode,"PRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

        if !empty(mDATEEND) .and. mDATEEND < FIRST_DAY  //0d20210101
        else
          select V002
          append blank
          V002->IDPR := val(mIDPR)
          V002->PRNAME := alltrim(mPRNAME)
          V002->DATEBEG := mDATEBEG
          V002->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 11.02.22
Function work_V016(source, destination)
  local _mo_V016 := {;
    {"IDDT",      "C",   3, 0},;  // ��� ⨯� ��ᯠ��ਧ�樨
    {"DTNAME",    "C", 254, 0},;  // ������������ ⨯� ��ᯠ��ਧ�樨
    {"RULE",      "C",  40, 0},;  // ���祭�� १���� ��ᯠ��ਧ�樨 (ᯨ᮪) (V017)
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local mRULE := ''
  local nfile, nameRef, j, k

  nameRef := "V016.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    CLOSE databases
    return nil
  endif

  dbcreate(destination + "_mo_v016", _mo_V016)
  use (destination + '_mo_v016') new alias V016
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� ⨯�� ��ᯠ��ਧ�樨 (DispT)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDDT := mo_read_xml_stroke(oXmlNode,"IDDT",)
        mDTNAME := mo_read_xml_stroke(oXmlNode,"DTNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        mRULE := ''
        if (oNode1 := oXmlNode:Find("DTRULE")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "RULE" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              mRULE := mRULE + iif(empty(mRULE), '', ',') + alltrim(oNode2:aItems[1])
            endif
          next
        endif

        select V016
        append blank
        V016->IDDT := mIDDT
        V016->DTNAME := mDTNAME
        V016->RULE := mRULE
        V016->DATEBEG := mDATEBEG
        V016->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 11.02.22
Function work_V017(source, destination)
  local _mo_V017 := {;
    {"IDDR",      "N",   2, 0},;  // ��� १���� ��ᯠ��ਧ�樨
    {"DRNAME",    "C", 254, 0},;  // ������������ १���� ��ᯠ��ਧ�樨
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V017.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    CLOSE databases
    return nil
  endif

  dbcreate(destination + "_mo_v017", _mo_V017)
  use (destination + '_mo_v017') new alias V017
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� १���⮢ ��ᯠ��ਧ�樨 (DispR)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDDR := mo_read_xml_stroke(oXmlNode,"IDDR",)
        mDRNAME := mo_read_xml_stroke(oXmlNode,"DRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

        select V017
        append blank
        V017->IDDR := val(mIDDR)
        V017->DRNAME := mDRNAME
        V017->DATEBEG := mDATEBEG
        V017->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 11.02.22
Function work_V021(source, destination)

  local _mo_V021 := {;
    {"IDSPEC",     "N",      3,      0},;
    {"SPECNAME",   "C",    250,      0},;
    {"POSTNAME",   "C",    250,      0},;
    {"IDPOST_MZ",  "C",      4,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "V021.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  dbcreate(destination + "_mo_v021", _mo_V021)
  use (destination + '_mo_V021') new alias V021
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩ (�������⥩) (MedSpec)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDSPEC := mo_read_xml_stroke(oXmlNode,"IDSPEC",)
        mSPECNAME := mo_read_xml_stroke(oXmlNode,"SPECNAME",)
        mPOSTNAME := mo_read_xml_stroke(oXmlNode,"POSTNAME",)
        mIDPOST_MZ := mo_read_xml_stroke(oXmlNode,"IDPOST_MZ",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

        if !empty(mDATEEND) .and. mDATEEND < 0d20180101
        else
          select V021
          append blank
          V021->IDSPEC := val(mIDSPEC)
          V021->SPECNAME := alltrim(mSPECNAME)
          V021->POSTNAME := alltrim(mPOSTNAME)
          V021->IDPOST_MZ := alltrim(mIDPOST_MZ)
          V021->DATEBEG := mDATEBEG
          V021->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

* 12.02.22 ������ ���ᨢ �� �ࠢ�筨�� ॣ����� ����� V002.xml
function getV002(destination)
  // V002.xml - 
  //  1 - PRNAME(C)  2 - IDPR(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local dbName := "_mo_V002"
  local _v002 := {}

  dbUseArea( .t.,, destination + dbName, dbName, .f., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
      aadd(_v002, { (dbName)->PRNAME, (dbName)->IDPR, (dbName)->DATEBEG, (dbName)->DATEEND })
      (dbName)->(dbSkip())
  enddo
  (dbName)->(dbCloseArea())

  return _v002

***** 11.02.22
Function work_V009(source, destination)
  local _mo_V009 := {;
    {"IDRMP",     "N",   3, 0},;  // ��� १���� ���饭��
    {"RMPNAME",   "C", 254, 0},;  // ������������ १���� ���饭��
    {"DL_USLOV",  "N",   2, 0},;  // ���⢥����� �᫮��� �������� ����樭᪮� ����� (V006)
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k
  
  nameRef := "V009.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  dbcreate(destination + "_mo_v009", _mo_V009)
  use (destination + '_mo_v009') new alias V009
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� १���⮢ ���饭�� �� ����樭᪮� ������� (Rezult)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDRMP := mo_read_xml_stroke(oXmlNode,"IDRMP",)
        mRMPNAME := mo_read_xml_stroke(oXmlNode,"RMPNAME",)
        mDL_USLOV := mo_read_xml_stroke(oXmlNode,"DL_USLOV",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V009
        append blank
        V009->IDRMP := val(mIDRMP)
        V009->RMPNAME := mRMPNAME
        V009->DL_USLOV := val(mDL_USLOV)
        V009->DATEBEG := mDATEBEG
        V009->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 11.02.22
Function work_V010(source, destination)
  local _mo_V010 := {;
    {"IDSP",      "N",   2, 0},;  // ��� ᯮᮡ� ������ ����樭᪮� �����
    {"SPNAME",    "C", 254, 0},;  // ������������ ᯮᮡ� ������ ����樭᪮� �����
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V010.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  dbcreate(destination + "_mo_v010", _mo_V010)
  use (destination + '_mo_v010') new alias V010
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� ᯮᮡ�� ������ ����樭᪮� ����� (Sposob)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDSP := mo_read_xml_stroke(oXmlNode,"IDSP",)
        mSPNAME := mo_read_xml_stroke(oXmlNode,"SPNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V010
        append blank
        V010->IDSP := val(mIDSP)
        V010->SPNAME := mSPNAME
        V010->DATEBEG := mDATEBEG
        V010->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 11.02.22
Function work_V012(source, destination)
  local _mo_V012 := {;
    {"IDIZ",      "N",   3, 0},;  // ��� ��室� �����������
    {"IZNAME",    "C", 254, 0},;  // ������������ ��室� �����������
    {"DL_USLOV",  "N",   2, 0},;  // ���⢥����� �᫮��� �������� �� (V006)
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V012.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v012", _mo_V012)
  use (destination + '_mo_v012') new alias V012
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� ��室�� ����������� (Ishod)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDIZ := mo_read_xml_stroke(oXmlNode,"IDIZ",)
        mIZNAME := mo_read_xml_stroke(oXmlNode,"IZNAME",)
        mDL_USLOV := mo_read_xml_stroke(oXmlNode,"DL_USLOV",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V012
        append blank
        V012->IDIZ := val(mIDIZ)
        V012->IZNAME := mIZNAME
        V012->DL_USLOV := val(mDL_USLOV)
        V012->DATEBEG := mDATEBEG
        V012->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

* 12.02.22 ������ ���ᨢ �� �ࠢ�筨�� ����� V021.xml
function getV021(destination)
  // V021.xml - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩ (��᫥����)
  //  1 - SPECNAME(C)  2 - IDSPEC(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local dbName := "_mo_V021"
  local _v021 := {}

  dbUseArea( .t.,, destination + dbName, dbName, .f., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
      aadd(_v021, { (dbName)->SPECNAME, (dbName)->IDSPEC, (dbName)->DATEBEG, (dbName)->DATEEND })
      (dbName)->(dbSkip())
  enddo
  (dbName)->(dbCloseArea())

  return _v021

***** 12.02.22
Function work_V015(source, destination)
  local _mo_V015 := {;
    {"NAME",   "C",  254,      0},;
    {"CODE",   "N",    4,      0},;
    {"HIGH",   "C",    4,      0},;
    {"OKSO",   "C",    3,      0},;
    {"DATEBEG","D",    8,      0},;
    {"DATEEND","D",    8,      0},;
    {"RECID",  "N",    3,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "V015.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v015", _mo_V015)
  use (destination + '_mo_V015') new alias V015
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩ (Medspec)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mRECID := mo_read_xml_stroke(oXmlNode,"RECID",)
        mCODE := mo_read_xml_stroke(oXmlNode,"CODE",)
        mNAME := mo_read_xml_stroke(oXmlNode,"NAME",)
        mHIGH := mo_read_xml_stroke(oXmlNode,"HIGH",)
        mOKSO := mo_read_xml_stroke(oXmlNode,"OKSO",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V015
        append blank
        V015->RECID := val(mRECID)
        V015->CODE := val(mCODE)
        V015->NAME := mNAME
        V015->HIGH := mHIGH
        V015->OKSO := mOKSO
        V015->DATEBEG := mDATEBEG
        V015->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL
  
***** 12.02.22
Function work_V018(source, destination)
  local _mo_V018 := {;
    {"IDHVID",     "C",     12,      0},;
    {"HVIDNAME",   "C",    254,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  // {"HVIDNAME",   "M",     10,      0},;
  local nfile, nameRef, j, k

  nameRef := "V018.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v018", _mo_V018)
  use (destination + '_mo_V018') new alias V018
  // index on kod to tmp_shema
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���� ��᮪��孮����筮� ����樭᪮� ����� (HVid)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDHVID := mo_read_xml_stroke(oXmlNode,"IDHVID",)
        mHVIDNAME := mo_read_xml_stroke(oXmlNode,"HVIDNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V018
        append blank
        V018->IDHVID := mIDHVID
        V018->HVIDNAME := mHVIDNAME
        V018->DATEBEG := mDATEBEG
        V018->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL
  
***** 10.02.22
Function work_V019(source, destination)
  local _mo_V019 := {;
    {"IDHM",       "N",      4,      0},; // �����䨪��� ��⮤� ��᮪��孮����筮� ����樭᪮� �����
    {"HMNAME",     "C",    254,      0},; // ������������ ��⮤� ��᮪��孮����筮� ����樭᪮� �����
    {"DIAG",       "M",     10,      0},; // ���孨� �஢�� ����� �������� �� ��� ��� ������� ��⮤�; 㪠�뢠���� �१ ࠧ����⥫� ";".
    {"HVID",       "C",     12,      0},; // ��� ���� ��᮪��孮����筮� ����樭᪮� ����� ��� ������� ��⮤�
    {"HGR",        "N",      3,      0},; // ����� ��㯯� ��᮪��孮����筮� ����樭᪮� ����� ��� ������� ��⮤�
    {"HMODP",      "C",    254,      0},; // ������ ��樥�� ��� ��⮤�� ��᮪��孮����筮� ����樭᪮� ����� � ��������묨 ���祭�ﬨ ���� "HMNAME". �� ����������, ��稭�� � ���ᨨ 3.0
    {"IDMODP",     "N",      5,      0},; // �����䨪��� ������ ��樥�� ��� ������� ��⮤� (��稭�� � ���ᨨ 3.0, ���������� ���祭��� ���� IDMPAC �����䨪��� V022)
    {"DATEBEG",    "D",      8,      0},; // ��� ��砫� ����⢨� �����
    {"DATEEND",    "D",      8,      0};  // ��� ����砭�� ����⢨� �����
  }
  // {"DIAG",       "C",    700,      0},; // ���孨� �஢�� ����� �������� �� ��� ��� ������� ��⮤�; 㪠�뢠���� �१ ࠧ����⥫� ";".
  local nfile, nameRef, j, k

  nameRef := "V019.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v019",_mo_V019)
  use (destination + '_mo_V019') new alias V019
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ��⮤� ��᮪��孮����筮� ����樭᪮� ����� (HMet)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDHM := mo_read_xml_stroke(oXmlNode,"IDHM",)
        mHMNAME := mo_read_xml_stroke(oXmlNode,"HMNAME",)
        mDIAG := mo_read_xml_stroke(oXmlNode,"DIAG",)
        mHVID := mo_read_xml_stroke(oXmlNode,"HVID",)
        mHGR := mo_read_xml_stroke(oXmlNode,"HGR",)
        mHMODP := mo_read_xml_stroke(oXmlNode,"HMODP",)
        mIDMODP := mo_read_xml_stroke(oXmlNode,"IDMODP",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V019
        append blank
        V019->IDHM := val(mIDHM)
        V019->HMNAME := mHMNAME
        V019->DIAG := mDIAG
        V019->HVID := mHVID
        V019->HGR := val(mHGR)
        if upper(alltrim(mHMODP)) != 'NULL'
          V019->HMODP := mHMODP
        endif
        V019->IDMODP := val(mIDMODP)
        // V019->DATEBEG := mDATEBEG
        V019->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        // V019->DATEEND := mDATEEND
        V019->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V020(source, destination)
  local _mo_V020 := {;
    {"IDK_PR",     "N",      3,      0},; // ��� ��䨫� �����
    {"K_PRNAME",   "C",    254,      0},; // ������������ ��䨫� �����
    {"DATEBEG",    "D",      8,      0},; // ��� ��砫� ����⢨� �����
    {"DATEEND",    "D",      8,      0};  // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V020.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v020", _mo_V020)
  use (destination + '_mo_v020') new alias V020
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� ��䨫� ����� (KoPr)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDK_PR := mo_read_xml_stroke(oXmlNode,"IDK_PR",)
        mK_PRNAME := mo_read_xml_stroke(oXmlNode,"K_PRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V020
        append blank
        V020->IDK_PR := val(mIDK_PR)
        V020->K_PRNAME := mK_PRNAME
        V020->DATEBEG := mDATEBEG
        V020->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 11.02.22
Function work_V022(source, destination)
  local _mo_V022 := {;
    {"IDMPAC",     "N",      5,      0},;
    {"MPACNAME",   "M",     10,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  // {"MPACNAME",   "C",   1250,      0},;
  local nfile, nameRef, j, k
  
  nameRef := "V022.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v022",_mo_V022)
  use (destination + '_mo_V022') new alias V022
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� ������� ��樥�� �� �������� ��᮪��孮����筮� ����樭᪮� ����� (ModPac)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDMPAC := mo_read_xml_stroke(oXmlNode,"IDMPAC",)
        mMPACNAME := mo_read_xml_stroke(oXmlNode,"MPACNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        if mDATEBEG >= FIRST_DAY .or. Empty(mDATEEND)  //0d20210101
          select V022
          append blank
          V022->IDMPAC := val(mIDMPAC)
          V022->MPACNAME := mMPACNAME
          V022->DATEBEG := mDATEBEG
          V022->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V025(source, destination)
  local _mo_V025 := {;
    {"IDPC",      "C",   3, 0},;  // ��� 楫� ���饭��
    {"N_PC",      "C", 254, 0},;  // ������������ 楫� ���饭��
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V025.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v025", _mo_V025)
  use (destination + '_mo_V025') new alias V025
  // index on kod to tmp_shema
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����䨪��� 楫�� ���饭�� (KPC)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mIDPC := mo_read_xml_stroke(oXmlNode,"IDPC",)
        mN_PC := mo_read_xml_stroke(oXmlNode,"N_PC",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V025
        append blank
        V025->IDPC := mIDPC
        V025->N_PC := mN_PC
        V025->DATEBEG := mDATEBEG
        V025->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V030(source, destination)
  local _mo_V030 := {;
    {"SCHEMCOD",  "C",   3, 0},;  // 
    {"SCHEME",    "C",  10, 0},;  //
    {"DEGREE",    "N",   2, 0},;  //
    {"COMMENT",   "M",  10, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V030.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v030", _mo_V030)
  use (destination + '_mo_V030') new alias V030
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �奬� ��祭�� ����������� COVID-19 (TreatReg)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mSchemCod := mo_read_xml_stroke(oXmlNode,"SchemCode",)
        mScheme := mo_read_xml_stroke(oXmlNode,"Scheme",)
        mDegree := mo_read_xml_stroke(oXmlNode,"DegreeSeverity",)
        mComment := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V030
        append blank
        V030->SCHEMCOD := mSchemCod
        V030->SCHEME := mScheme
        V030->DEGREE := val(mDegree)
        V030->COMMENT := mComment
        V030->DATEBEG := mDATEBEG
        V030->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V031(source, destination)
  local _mo_V031 := {;
    {"DRUGCODE",  "N",   2, 0},;  // 
    {"DRUGGRUP",  "C",  50, 0},;  //
    {"INDMNN",    "N",   2, 0},;  // �ਧ��� ��易⥫쭮�� 㪠����� ��� (1-��, 0-���)
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V031.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v031", _mo_V031)
  use (destination + '_mo_V031') new alias V031
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ��㯯� �९��⮢ ��� ��祭�� ����������� COVID-19 (GroupDrugs)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mDrugCode := mo_read_xml_stroke(oXmlNode,"DrugGroupCode",)
        mDrugGrup := mo_read_xml_stroke(oXmlNode,"DrugGroup",)
        mIndMNN := mo_read_xml_stroke(oXmlNode,"ManIndMNN",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V031
        append blank
        V031->DRUGCODE := val(mDrugCode)
        V031->DRUGGRUP := mDrugGrup
        V031->INDMNN := val(mIndMNN)
        V031->DATEBEG := mDATEBEG
        V031->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V032(source, destination)
  local _mo_V032 := {;
    {"SCHEDRUG",  "C",  10, 0},;  // ���⠭�� �奬� ��祭�� � ��㯯� �९��⮢
    {"NAME",      "C", 100, 0},;  //
    {"SCHEMCOD",  "C",   3, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V032.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v032", _mo_V032)
  use (destination + '_mo_V032') new alias V032
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���⠭�� �奬� ��祭�� � ��㯯� �९��⮢ (CombTreat)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mScheDrug := mo_read_xml_stroke(oXmlNode,"ScheDrugGrCd",)
        mName := mo_read_xml_stroke(oXmlNode,"Name",)
        mSchemCod := mo_read_xml_stroke(oXmlNode,"SchemCode",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V032
        append blank
        V032->SCHEDRUG := mScheDrug
        V032->NAME := mName
        V032->SCHEMCOD := mSchemCod
        V032->DATEBEG := mDATEBEG
        V032->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V033(source, destination)
  local _mo_V033 := {;
    {"SCHEDRUG",  "C",   5, 0},;  // 
    {"DRUGCODE",  "C",   6, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V033.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v033", _mo_V033)
  use (destination + '_mo_V033') new alias V033
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���⢥��⢨� ���� �९��� �奬� ��祭�� (DgTreatReg)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mScheDrug := mo_read_xml_stroke(oXmlNode,"ScheDrugGrCd",)
        mDrugCode := mo_read_xml_stroke(oXmlNode,"DrugCode",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V033
        append blank
        V033->SCHEDRUG := mScheDrug
        V033->DRUGCODE := mDrugCode
        V033->DATEBEG := mDATEBEG
        V033->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V034(source, destination)
  local _mo_V034 := {;
    {"UNITCODE",  "N",   3, 0},;  // ��� ������� ����७�� ����
    {"UNITMEAS",  "C",  50, 0},;  //
    {"SHORTTIT",  "C",  15, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V034.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v034", _mo_V034)
  use (destination + '_mo_V034') new alias V034
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ������� ����७�� (UnitMeas)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mUnitCode := mo_read_xml_stroke(oXmlNode,"UnitCode",)
        mUnitMeas := mo_read_xml_stroke(oXmlNode,"UnitMeasur",)
        mShortTit := mo_read_xml_stroke(oXmlNode,"ShortTitle",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V034
        append blank
        V034->UNITCODE := val(mUnitCode)
        V034->UNITMEAS := mUnitMeas
        V034->SHORTTIT := mShortTit
        V034->DATEBEG := mDATEBEG
        V034->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V035(source, destination)
  local _mo_V035 := {;
    {"METHCODE",  "N",   3, 0},;  // 
    {"METHNAME",   "C",  50, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V035.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v035", _mo_V035)
  use (destination + '_mo_V035') new alias V035
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���ᮡ� �������� (MethIntro)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mMethCode := mo_read_xml_stroke(oXmlNode,"MethCode",)
        mMethName := mo_read_xml_stroke(oXmlNode,"MethNam",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V035
        append blank
        V035->METHCODE := val(mMethCode)
        V035->METHNAME := mMethName
        V035->DATEBEG := mDATEBEG
        V035->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V036(source, destination)
  local _mo_V036 := {;
    {"S_CODE",    "C",  16, 0},;  // 
    {"NAME",      "C", 150, 0},;  //
    {"PARAM",     "N",   1, 0},;  //
    {"COMMENT",   "C",  20, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V036.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v036", _mo_V036)
  use (destination + '_mo_V036') new alias V036
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���祭� ���, �ॡ���� ��������� ����樭᪨� ������� (ServImplDv)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mS_Code := mo_read_xml_stroke(oXmlNode,"S_CODE",)
        mName := mo_read_xml_stroke(oXmlNode,"NAME",)
        mParam := mo_read_xml_stroke(oXmlNode,"Parameter",)
        mComment := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V036
        append blank
        V036->S_CODE := mS_Code
        V036->NAME := mName
        V036->PARAM := val(mParam)
        V036->COMMENT := mComment
        V036->DATEBEG := mDATEBEG
        V036->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function work_V037(source, destination)
  local _mo_V037 := {;
    {"CODE",      "N",   5, 0},;  // 
    {"NAME",      "C", 150, 0},;  //
    {"PARAM",     "N",   1, 0},;  //
    {"COMMENT",   "C",  20, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local nfile, nameRef, j, k

  nameRef := "V037.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v037", _mo_V037)
  use (destination + '_mo_V037') new alias V037
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���祭� ��⮤�� ���, �ॡ���� ��������� ����樭᪨� �������" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        mCode := mo_read_xml_stroke(oXmlNode,"CODE",)
        mName := mo_read_xml_stroke(oXmlNode,"NAME",)
        mParam := mo_read_xml_stroke(oXmlNode,"Parameter",)
        mComment := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V037
        append blank
        V037->CODE := val(mCode)
        V037->NAME := mName
        V037->PARAM := val(mParam)
        V037->COMMENT := mComment
        V037->DATEBEG := mDATEBEG
        V037->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function make_Q015(source, destination)

  local _mo_Q015 := {;
    {"KOD",       "C",     12,      0},;
    {"NAME",      "C",     60,      0},;
    {"NSI_OBJ",   "C",      4,      0},;
    {"NSI_EL",    "C",     20,      0},;
    {"USL_TEST",  "M",     10,      0},;
    {"VAL_EL",    "M",     10,      0},;
    {"COMMENT",   "M",     10,      0},;
    {"DATEBEG",   "D",      8,      0},;
    {"DATEEND",   "D",      8,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "Q015.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_q015", _mo_Q015)
  use (destination + '_mo_Q015') new alias Q015
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���祭� �孮�����᪨� �ࠢ�� ॠ����樨 ��� � �� ������� ���ᮭ���஢������ ��� ᢥ����� �� ��������� ����樭᪮� ����� (FLK_MPF)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        select Q015
        append blank
        Q015->KOD := mo_read_xml_stroke(oXmlNode,"ID_TEST",)
        Q015->NAME := mo_read_xml_stroke(oXmlNode,"ID_EL",)

        Q015->NSI_OBJ := mo_read_xml_stroke(oXmlNode,"NSI_OBJ",)
        Q015->NSI_EL := mo_read_xml_stroke(oXmlNode,"NSI_EL",)
        Q015->USL_TEST := mo_read_xml_stroke(oXmlNode,"USL_TEST",)
        Q015->VAL_EL := mo_read_xml_stroke(oXmlNode,"VAL_EL",)
        Q015->COMMENT := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        Q015->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        Q015->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function make_Q016(source, destination)

  local _mo_Q016 := {;
    {"KOD",       "C",     12,      0},;
    {"NAME",      "C",     60,      0},;
    {"NSI_OBJ",   "C",      4,      0},;
    {"NSI_EL",    "C",     20,      0},;
    {"USL_TEST",  "M",     10,      0},;
    {"VAL_EL",    "M",     10,      0},;
    {"COMMENT",   "M",     10,      0},;
    {"DATEBEG",   "D",      8,      0},;
    {"DATEEND",   "D",      8,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "Q016.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_q016", _mo_Q016)
  use (destination + '_mo_Q016') new alias Q016
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���祭� �஢�ப ��⮬�⨧�஢����� �����প� ��� � �� ������� ���ᮭ���஢������ ��� ᢥ����� �� ��������� ����樭᪮� ����� (MEK_MPF)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        select Q016
        append blank
        Q016->KOD := mo_read_xml_stroke(oXmlNode,"ID_TEST",)
        Q016->NAME := mo_read_xml_stroke(oXmlNode,"DESC_TEST",)

        Q016->NSI_OBJ := mo_read_xml_stroke(oXmlNode,"NSI_OBJ",)
        Q016->NSI_EL := mo_read_xml_stroke(oXmlNode,"NSI_EL",)
        Q016->USL_TEST := mo_read_xml_stroke(oXmlNode,"USL_TEST",)
        Q016->VAL_EL := mo_read_xml_stroke(oXmlNode,"VAL_EL",)
        Q016->COMMENT := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        Q016->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        Q016->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
    
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function make_Q017(source, destination)

  local _mo_Q017 := {;
    {"ID_KTEST",   "C",      4,      0},;
    {"NAM_KTEST",  "C",    250,      0},;
    {"COMMENT",    "M",     10,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "Q017.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_q017", _mo_Q017)
  use (destination + '_mo_Q017') new alias Q017
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - ���祭� ��⥣�਩ �஢�ப ��� � ��� (TEST_K)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        select Q017
        append blank
        Q017->ID_KTEST := mo_read_xml_stroke(oXmlNode,"ID_KTEST",)
        Q017->NAM_KTEST := mo_read_xml_stroke(oXmlNode,"NAM_KTEST",)
        Q017->COMMENT := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        Q017->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        Q017->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
    
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function make_O001(source, destination)

    //  1 - NAME11(C)  2 - KOD(C)  3 - DATEBEG(D)  4 - DATEEND(D)  5 - ALFA2(C)  6 - ALFA3(C)
    local _mo_O001 := {;
    {"KOD",     "C",    3,      0},;
    {"NAME11",  "C",   60,      0},;
    {"NAME12",  "C",   60,      0},;
    {"ALFA2",   "C",    2,      0},;
    {"ALFA3",   "C",    3,      0},;
    {"DATEBEG", "D",    8,      0},;
    {"DATEEND", "D",    8,      0};
  }
  local mName := '', mArr
  local nfile, nameRef, j, k

  nameRef := "O001.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_o001", _mo_O001)
  use (destination + '_mo_O001') new alias O001
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - �����ᨩ᪨� �����䨪��� ��࠭ ��� (OKSM)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        select O001
        append blank
        mArr := hb_ATokens( mo_read_xml_stroke(oXmlNode,"NAME11",), '^' )
        O001->KOD := mo_read_xml_stroke(oXmlNode,"KOD",)
        if len(mArr) == 1
          O001->NAME11 := mArr[1]
        else
          O001->NAME11 := mArr[1]
          O001->NAME12 := mArr[2]
        endif
        O001->ALFA2 := mo_read_xml_stroke(oXmlNode,"ALFA2",)
        O001->ALFA3 := mo_read_xml_stroke(oXmlNode,"ALFA3",)
        O001->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        O001->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
    
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function make_F006(source, destination)

  //  1 - VIDNAME(C)  2 - IDVID(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local _mo_F006 := {;
    { 'IDVID',      'N',    2,      0 },;
    { 'VIDNAME',    'M',   10,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local nfile, nameRef, j, k
  local mName := '', mArr

  nameRef := 'F006.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + '_mo_f006', _mo_F006)
  use (destination + '_mo_f006') new alias F006
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + ' - �����䨪��� ����� ����஫� (VidExp)' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        select F006
        append blank
        F006->IDVID := val(mo_read_xml_stroke(oXmlNode, 'IDVID',))
        F006->VIDNAME := mo_read_xml_stroke(oXmlNode, 'VIDNAME',)
        F006->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode, 'DATEBEG',))
        F006->DATEEND := ctod(mo_read_xml_stroke(oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function make_F010(source, destination)

  //  1 - SUBNAME(C) 2 - KOD_TF(N)  3 - OKRUG(N)  4 - KOD_OKATO(C)  5 - DATEBEG(D)  6 - DATEEND(D)
  local _mo_F010 := {;
    { 'KOD_TF',     'C',    2,      0 },;
    { 'KOD_OKATO',  'C',    5,      0 },;
    { 'SUBNAME',    'C',  250,      0 },;
    { 'OKRUG',      'N',    1,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local nfile, nameRef, j, k
  local mName := '', mArr

  nameRef := 'F010.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + '_mo_f010', _mo_F010)
  use (destination + '_mo_F010') new alias F010
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + ' - �����䨪��� ��ꥪ⮢ ���ᨩ᪮� �����樨 (Subekti)' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        select F010
        append blank
        F010->KOD_TF := mo_read_xml_stroke(oXmlNode, 'KOD_TF',)
        F010->KOD_OKATO := mo_read_xml_stroke(oXmlNode, 'KOD_OKATO',)
        F010->SUBNAME := mo_read_xml_stroke(oXmlNode, 'SUBNAME',)
        F010->OKRUG := val(mo_read_xml_stroke(oXmlNode, 'OKRUG',))
        F010->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode, 'DATEBEG',))
        F010->DATEEND := ctod(mo_read_xml_stroke(oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function make_F011(source, destination)

  //  1 - DOCNAME(C)  2 - IDDOC(N) 3 - DOCSER(C) 4 - DOCNUM(C) 5 - DATEBEG(D)  6 - DATEEND(D)
  local _mo_F011 := {;
    { 'IDDOC',      'N',    2,      0 },;
    { 'DOCNAME',    'C',  250,      0 },;
    { 'DOCSER',     'C',   10,      0 },;
    { 'DOCNUM',     'C',   20,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local nfile, nameRef, j, k
  local mName := '', mArr

  nameRef := 'F011.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + '_mo_f011', _mo_F011)
  use (destination + '_mo_f011') new alias F011
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + ' - �����䨪��� ⨯�� ���㬥�⮢, 㤮�⮢������ ��筮��� (Tipdoc)' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        select F011
        append blank
        F011->IDDOC := val(mo_read_xml_stroke(oXmlNode, 'IDDOC',))
        F011->DOCNAME := mo_read_xml_stroke(oXmlNode, 'DOCNAME',)
        F011->DOCSER := mo_read_xml_stroke(oXmlNode, 'DOCSER',)
        F011->DOCNUM := mo_read_xml_stroke(oXmlNode, 'DOCNUM',)
        F011->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode, 'DATEBEG',))
        F011->DATEEND := ctod(mo_read_xml_stroke(oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 12.02.22
Function make_F014(source, destination)

  local _mo_F014 := {;
    {'KOD',     'N',      4,      0},;
    {'NAME',    'C',    250,      0},;
    {'OPIS',    'M',     10,      0},;
    {'DATEBEG', 'D',      8,      0},;
    {'DATEEND', 'D',      8,      0},;
    {'OSN',     'C',     20,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "F014.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_f014",_mo_F014)
  use (destination + '_mo_F014') new alias F014
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + ' - �����䨪��� ��稭 �⪠�� � ����� ����樭᪮� ����� (OplOtk)' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        out_obrabotka_count(j, k)
        select F014
        append blank
        F014->KOD := val( mo_read_xml_stroke(oXmlNode, 'KOD',) )
        F014->NAME := mo_read_xml_stroke(oXmlNode, 'KOMMENT',)
        F014->OPIS := mo_read_xml_stroke(oXmlNode, 'NAIM',)
        F014->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode, 'DATEBEG',))
        F014->DATEEND := ctod(mo_read_xml_stroke(oXmlNode, 'DATEEND',))
        F014->OSN := mo_read_xml_stroke(oXmlNode, 'OSN',)
    
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

*****
Function InitSpravFFOMS(source, destination)

  // V002.dbf - �����䨪��� ��䨫�� ��������� ����樭᪮� �����
  //  1 - PRNAME(C)  2 - IDPR(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  Public glob_V002 := getV002(destination)
  
  // V021.xml - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩ (��᫥����)
  //  1 - SPECNAME(C)  2 - IDSPEC(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  Public glob_V021 := getV021(destination)
  return NIL
