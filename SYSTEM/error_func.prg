#include 'function.ch'
#include 'tfile.ch'
#include '.\dict_error.ch'

// 31.07.23
function out_error(fp, nError, nfile, j, k)

  do case
    case nError == FILE_NOT_EXIST
      fp:add_string('���� ', nfile, ' �� �������')
    case nError == FILE_READ_ERROR
      fp:add_string('�訡�� � ����㧪� 䠩�� ', nfile)
    case nError == FILE_RENAME_ERROR
      fp:add_string('�訡�� ��२��������� 䠩�� ', nfile)
    case nError == DIR_IN_NOT_EXIST
      fp:add_string('��⠫�� ��室��� ������ "', nfile, '" �� �������. �த������� ࠡ��� �� ��������!')
    case nError == DIR_OUT_NOT_EXIST
      fp:add_string('��⠫�� ��� ��室��� ������ "', nfile, '" �� �������. �த������� ࠡ��� �� ��������!')
    case nError == TAG_YEAR_REPORT
      fp:add_string('�訡�� �� �⥭�� 䠩�� "', nfile, '". �����४⭮� ���祭�� ⥣� YEAR_REPORT ', j)
    case nError == TAG_PLACE_ERROR
      fp:add_string('�訡�� �� �⥭�� 䠩�� "', nfile, '" - ����� ������ ⥣� PLACE � �⤥�����: ', alltrim(j))
    case nError == TAG_PERIOD_ERROR
      fp:add_string('�訡�� �� �⥭�� 䠩�� "', nfile, '" - ����� ������ ⥣� PERIOD � ��०�����: ', j, ' � ��㣥 ', k)
    case nError == TAG_VALUE_EMPTY
      fp:add_string('����砭�� �� �⥭�� 䠩�� "', nfile, '" - ���⮥ ���祭�� ⥣� VALUE/LEVEL: ', j, ' � ��㣥 ', k)
    case nError == TAG_VALUE_INVALID
      fp:add_string('����砭�� �� �⥭�� 䠩�� "', nfile, '" - �����४⭮� ���祭�� ⥣� VALUE/LEVEL: ', j, ' � ��㣥 ', k)
    case nError == TAG_ROW_INVALID
      fp:add_string('�訡�� �� ����㧪� ��ப� - ', j, ' �� 䠩�� ', nfile)
    case nError == UPDATE_TABLE_ERROR
      fp:add_string('�訡�� ���������� ����ᥩ � ⠡��� - ', nfile)
    case nError == PACK_ERROR
      fp:add_string('�訡�� �� ���⪨ �� - ', nfile)
    case nError == INVALID_COMMAND_LINE
      fp:add_string('������⭮� �ᯮ�짮����� ��権 -all � -update �������⨬�')
  end case

  return nil
