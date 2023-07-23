


// 02.11.15
Function hard_err(p)
// k = 1 - проверка диска на наличие временного файла hard_err.meh
//         и, если он есть, вывод текста о необходимости переиндексирования;
//         создание временного файла hard_err.meh 'CREATE'
// k = 2 - удаление временного файла hard_err.meh 'DELETE'
  Local k := 3, arr := {}

  if valtype(p) == 'N'
    k := p
  elseif valtype(p) == 'C'
    p := upper(p)
    do case
      case p == 'CREATE'
        k := 1
      case p == 'DELETE'
        k := 2
    endcase
  endif
  do case
    case k == 1
      if file('hard_err.meh')
        FillScreen(p_char_screen, p_color_screen)
        aadd(arr,'Последний раз при выходе из задачи был сбой по питанию.')
        aadd(arr,'. . .')
        aadd(arr,'Поэтому Вам настоятельно рекомендуется выполнить')
        aadd(arr,'режим "Переиндексирование", т.к. вполне вероятно, что')
        aadd(arr,'некоторые индексные файлы были испорчены или разрушены.')
        keyboard ''
        f_message(arr, , color1, color8, , , color1)
        if f_alert({padc('Выберите действие', 60, '.')}, ;
               {' Выход из задачи ', ' Продолжение работы '}, ;
               1, 'W+/N', 'N+/N', 20, , 'W+/N, N/BG' ) != 2
          SET COLOR TO
          SET CURSOR ON
          CLS
          QUIT
        endif
        FillScreen(p_char_screen, p_color_screen)
      endif
      strfile('hard_error', 'hard_err.meh')
    case k == 2
      delete file hard_err.meh
  endcase
  return NIL

// 22.07.23
FUNCTION f_end(yes_copy)
  Static group_ini := 'RAB_MESTO'
  Local i, spath := '', bSaveHandler := ERRORBLOCK( {|x| BREAK(x)} )

  ERRORBLOCK(bSaveHandler)
  //
  hard_err('delete')
  if __mvExist( 'cur_dir()' )
	  filedelete(cur_dir() + 'tmp*.dbf')
	  filedelete(cur_dir() + 'tmp*.ntx')
	  filedelete(_tmp_dir1 + '*.*')
	  if hb_DirExists(cur_dir() + _tmp_dir) .and. hb_DirDelete(cur_dir() + _tmp_dir) != 0
		  //func_error(4, 'Не могу удалить каталог ''+'cur_dir()'+'_tmp_dir)
	  endif
	  filedelete(_tmp2dir1 + '*.*')
	  if hb_DirExists(cur_dir() + _tmp2dir) .and. hb_DirDelete(cur_dir() + _tmp2dir) != 0
		  //func_error(4, 'Не могу удалить каталог ' + cur_dir() + _tmp2dir)
	  endif
  endif
  // удалим файлы отчетов в формате '*.HTML' из временной директории
  filedelete( HB_DirTemp() + '*.html')
  SET KEY K_ALT_F3 TO
  SET KEY K_ALT_F2 TO
  SET KEY K_ALT_X  TO
  SET COLOR TO
  SET CURSOR ON
  CLS
  QUIT
  RETURN NIL

// вернуть имя задачи по цифровому коду
Function f_name_task(n_Task)
  Local it, s

  DEFAULT n_Task TO glob_task
  s := lstr(n_Task)
  if (it := ascan(array_tasks, {|x| x[2] == n_Task})) > 0
    s := array_tasks[it, 1]
  endif
  return s

// проверить, доступна ли данному МО конкретная задача
Function is_task(n_Task)
  Local it

  if !(type('array_tasks') == 'A') // в начале задачи  ещё не определён массив
    return .f.
  endif
  DEFAULT n_Task TO glob_task
  if (it := ascan(array_tasks, {|x| x[2] == n_Task})) == 0
    return .f.
  endif
  return array_tasks[it, 4]

// вернуть индекс массива конкретной задачи
Function ind_task(n_Task)
  Local it

  DEFAULT n_Task TO glob_task
  if (it := ascan(array_tasks, {|x| x[2] == n_Task})) == 0
    it := 3 // ОМС
  endif
  return it