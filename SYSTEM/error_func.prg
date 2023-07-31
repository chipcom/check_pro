#include 'function.ch'
#include 'tfile.ch'
#include '.\dict_error.ch'

// 31.07.23
function out_error(fp, nError, nfile, j, k)

  do case
    case nError == FILE_NOT_EXIST
      fp:add_string('Файл ', nfile, ' не существует')
    case nError == FILE_READ_ERROR
      fp:add_string('Ошибка в загрузке файла ', nfile)
    case nError == FILE_RENAME_ERROR
      fp:add_string('Ошибка переименования файла ', nfile)
    case nError == DIR_IN_NOT_EXIST
      fp:add_string('Каталог исходных данных "', nfile, '" не существует. Продолжение работы не возможно!')
    case nError == DIR_OUT_NOT_EXIST
      fp:add_string('Каталог для выходных данных "', nfile, '" не существует. Продолжение работы не возможно!')
    case nError == TAG_YEAR_REPORT
      fp:add_string('Ошибка при чтении файла "', nfile, '". Некорректное значение тега YEAR_REPORT ', j)
    case nError == TAG_PLACE_ERROR
      fp:add_string('Ошибка при чтении файла "', nfile, '" - более одного тега PLACE в отделении: ', alltrim(j))
    case nError == TAG_PERIOD_ERROR
      fp:add_string('Ошибка при чтении файла "', nfile, '" - более одного тега PERIOD в учреждении: ', j, ' в услуге ', k)
    case nError == TAG_VALUE_EMPTY
      fp:add_string('Замечание при чтении файла "', nfile, '" - пустое значение тега VALUE/LEVEL: ', j, ' в услуге ', k)
    case nError == TAG_VALUE_INVALID
      fp:add_string('Замечание при чтении файла "', nfile, '" - некорректное значение тега VALUE/LEVEL: ', j, ' в услуге ', k)
    case nError == TAG_ROW_INVALID
      fp:add_string('Ошибка при загрузки строки - ', j, ' из файла ', nfile)
    case nError == UPDATE_TABLE_ERROR
      fp:add_string('Ошибка обновления записей в таблице - ', nfile)
    case nError == PACK_ERROR
      fp:add_string('Ошибка при очистки БД - ', nfile)
    case nError == INVALID_COMMAND_LINE
      fp:add_string('Совместное использование опций -all и -update недопустимо')
  end case

  return nil
