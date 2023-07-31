#include 'function.ch'

function read_xml_stroke_1251_to_utf8(node, title)
  local stroke

  stroke := mo_read_xml_stroke(node, title)
  // return hb_strToUTF8(mo_read_xml_stroke(node, title, , , 'win1251'), 'RU866')
  // return hb_strToUTF8(mo_read_xml_stroke(node, title, , , 'win1251'), 'RU1251')
  return Hb_Translate( stroke, 'RU1251', 'CP866')

// ��ப� ���� ��� XML-䠩��
Function date2xml(mdate)
  return strzero(year(mdate), 4) + '-' + ;
     strzero(month(mdate), 2) + '-' + ;
     strzero(day(mdate), 2)

// �ॡࠧ����� ���� �� "2002-02-01" � ⨯ "DATE"
Function xml2date(s)
  return stod(charrem('-', s))

// �஢���� ����稥 � XML-䠩�� �� � ������ ��� ���祭��
Function mo_read_xml_stroke(_node, _title, _aerr, _binding, _codepage)
  // _node - 㪠��⥫� �� 㧥�
  // _title - ������������ ��
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  // _codepage - ����஢�� ��।����� ��ப�
  Local ret := '', oNode, yes_err := (valtype(_aerr) == 'A'), ;
    s_msg := '��������� ���祭�� ��易⥫쭮�� �� "' + _title + '"'

  DEFAULT _binding TO .t., _aerr TO {}

  DEFAULT _codepage TO 'WIN1251'
  // �饬 ����室��� "_title" �� � 㧫� "_node"
  oNode := _node:Find(_title)
  if oNode == NIL .and. _binding .and. yes_err
    aadd(_aerr, s_msg)
  endif
  if oNode != NIL
    ret := mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  endif
  return ret

// ������ ���祭�� ��
Function mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  // oNode - 㪠��⥫� �� 㧥�
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  // _codepage - ����஢�� ��।����� ��ப�
  Local ret := '', c, yes_err := (valtype(_aerr) == 'A'), ;
    s_msg := '��������� ���祭�� ��易⥫쭮�� �� "' + oNode:title + '"'
  local codepage := upper(_codepage)

  if empty(oNode:aItems)
    if _binding .and. yes_err
      aadd(_aerr, s_msg)
    endif
  elseif (c := valtype(oNode:aItems[1])) == 'C'
    // if codepage == 'WIN1251'
    //   ret := hb_AnsiToOem(alltrim(oNode:aItems[1]))
    // elseif codepage == 'RU1251'
    //   // ret := hb_strToUTF8(alltrim(oNode:aItems[1]), 'ru1251')
    //   if HB_ISSTRING(oNode:aItems[1])
    //     ret := alltrim(hb_strToUTF8(oNode:aItems[1]), 'ru1251')
    //   endif
    // elseif codepage == 'UTF8'
      // ret := hb_Utf8ToStr( alltrim(oNode:aItems[1]), 'RU866' )	
      ret := alltrim(oNode:aItems[1])
    // endif
  elseif yes_err
    aadd(_aerr, '������ ⨯ ������ � �� "' + oNode:title + '": "' + c + '"')
  endif
  return ret