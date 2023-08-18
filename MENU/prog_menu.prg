#include 'set.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'

// 23.07.23
Function prog_menu(n_Task)
  Local it, s, k, fl := .t., cNameIcon

  private main_menu := {}
  private main_message := {}
  private first_menu := {}
  private first_message := {}
  private func_menu := {}
  private cmain_menu := {}
  private blk_ekran := {|| devpos(maxrow() - 2, maxcol() - len(dir_server())), ;
                        devout(upper(dir_server()),'W+/N*') }


  sys_date := DATE()
  put_icon(__full_name(), 'MAIN_ICON') // перевывести заголовок окна
  SETCOLOR(color1)
  FillScreen(p_char_screen, p_color_screen)
  do case
    case n_task == X_PASSWORD
      aadd(cmain_menu, 1)
      aadd(main_menu,' ~Пароли ')
      aadd(main_message,'Процедура отмены регистрации электронных документов в задаче CHIP_MO')
      aadd(first_menu, {'~Реестр СП и ТК с удалением счетов', ;
                        'Реестр ~актов контроля', 0, ;
                        '~Откат счёта и создание XML-файла счёта', ;
                        '~Удаление счёта и перевыставление случаев';
                       })
      aadd(first_message, { ;
                          'Пароль для отмены регистрации реестра СП и ТК с удалением счетов', ;
                          'Пароль для отмены регистрации реестра актов контроля', ;
                          'Пароль для отмены регистрации счёта и создание XML-файла счёта', ;
                          'Пароль для удаление счёта и перевыставление случаев';
                        })
      aadd(func_menu, {'cre_pas(1)', ;
                       'cre_pas(2)', ;
                       'cre_pas(3)', ;
                       'cre_pas(4)';
                      })
      //
      // aadd(cmain_menu, 34)
      // aadd(main_menu,' ~Информация ')
      // aadd(main_message,'Просмотр / печать статистики по пациентам')
      // aadd(first_menu, {'Статистика по прие~мам', ;
      //                   'Информация по ~картотеке', ;
      //                   '~Многовариантный поиск';
      //                  })
      // aadd(first_message, { ;
      //                     'Статистика по первичным врачебным приемам', ;
      //                     'Просмотр / печать списков по категориям, компаниям, районам, участкам,...', ;
      //                     'Многовариантный поиск в картотеке';
      //                     })
      // aadd(func_menu, {'regi_stat()', ;
      //                  'prn_kartoteka()', ;
      //                  'ne_real()' ;
      //                 })
      // //
      // aadd(cmain_menu, 51)
      // aadd(main_menu,' ~Справочники ')
      // aadd(main_message,'Ведение справочников')
      // aadd(first_menu, {'Первичные ~приемы', 0, ;
      //                   '~Настройка (умолчания)';
      //                  })
      // aadd(first_message, { ;  // справочники
      //                     'Редактирование справочника по первичным врачебным приемам', ;
      //                     'Настройка значений по умолчанию';
      //                     })
      // aadd(func_menu, {'edit_priem()', ;
      //                  'regi_nastr(2)';
      //                 })
  case n_task == X_SERVICE
    private glob_mo
    public is_otd_dep := .f., glob_otd_dep := 0, mm_otd_dep := {}
    glob_mo := begin_task_services()
    aadd(cmain_menu, 1)
    aadd(main_menu,' ~Услуги ')
    aadd(main_message,'Просмотр допустимых услуг для медицинской организации')
    aadd(first_menu, {'~Проверка допустимости услуги', ;
                      '~Список услуг', 0, ;
                      'В другое ~отделение', 0, ;
                      '~Удаление'})
    aadd(first_message, {;
        'Проверка открытия услуги для организации', ;
        'Просмотр списка допустимых услуг', ;
        'Перевод больного из одного отделения в другое', ;
        'Удаление истории болезни';
      } )
    aadd(func_menu, {'ne_real()', ;
                     'print_uslugi()', ;
                     'ne_real()', ;
                     'ne_real()'})
  //   aadd(cmain_menu, 34)
  //   aadd(main_menu,' ~Информация ')
  //   aadd(main_message,'Просмотр / печать статистики по больным')
  //   aadd(first_menu, {'~Журнал регистрации', ;
  //                     'Журнал по ~запросу', 0, ;
  //                     '~Сводная информация', 0, ;
  //                     '~Перевод м/у отделениями', 0, ;
  //                     'Поиск ~ошибок'})
  //   aadd(first_message, {;
  //       'Просмотр/печать журнала регистрации стационарных больных', ;
  //       'Просмотр/печать журнала регистрации стационарных больных по запросу', ;
  //       'Подсчет количества принятых больных с разбивкой по отделениям', ;
  //       'Получение информации о переводе между отделениями', ;
  //       'Поиск ошибок ввода';
  //     } )
  //   aadd(func_menu, {'pr_gurnal_pp()', ;
  //                    'z_gurnal_pp()', ;
  //                    'pr_svod_pp()', ;
  //                    'pr_perevod_pp()', ;
  //                    'pr_error_pp()'})
  //   aadd(cmain_menu, 51)
  //   aadd(main_menu,' ~Справочники ')
  //   aadd(main_message,'Ведение справочников')
  //   aadd(first_menu, {'~Столы', ;
  //                     '~Настройка'})
  //   aadd(first_message, {;
  //       'Работа со справочником столов', ;
  //       'Настройка значений по умолчанию';
  //     } )
  //   aadd(func_menu, {'f_pp_stol()', ;
  //                    'pp_nastr()'})
  case n_task == X_IMPORT
    aadd(cmain_menu, 1)
    aadd(main_menu,' ~Импорт справочников')
    aadd(main_message,'Импорт справочников для приложения')
    aadd(first_menu, {'~Справочники ТФОМС', ;
                      'Справочники ~ФФОМС', 0, ;
                      'В другое ~отделение', 0, ;
                      '~Удаление'})
    aadd(first_message, {;
        'Импорт справочников ТФОМС Волгоградской области', ;
        'Импорт справочников ФФОМС в sql-файл', ;
        'Перевод больного из одного отделения в другое', ;
        'Удаление истории болезни';
      } )
    aadd(func_menu, {'run_tfomsimport()', ;
                     'run_ffomsimport()', ;
                     'ne_real()', ;
                     'ne_real()'})
  endcase
  aadd(cmain_menu, 30)
  aadd(main_menu,' ~Настройки ')
  aadd(main_message,'Настройки')
  aadd(first_menu, {'~Общие настройки',0, ;
                    'Справочники ~ФФОМС',0, ;
                    '~Рабочее место'} )
  aadd(first_message, { ;
      'Настройка конвертации файлов', ;
      'Настройка содержимого справочников ФФОМС (уменьшение количества строк)', ;
      'Настройка рабочего места';
    } )
  aadd(func_menu, {'nastr_convert_files()', ;
                   'ne_real()', ;
                   'ne_real()'} )
  // последнее меню для всех одно и то же
  // aadd(cmain_menu, maxcol() - 9)
  // aadd(main_menu,' Помо~щь ')
  // aadd(main_message, 'Помощь, настройка принтера')
  // aadd(first_menu, {'~Новое в программе', ;
  //                   'Помо~щь', ;
  //                   '~Рабочее место', ;
  //                   '~Принтер', 0, ;
  //                   'Периндексация рабочего каталога', ;
  //                   'Сетевой ~монитор', ;
  //                   '~Ошибки'})
  // aadd(first_message, { ;
  //                     'Вывод на экран содержания файла README.RTF с текстом нового в программе', ;
  //                     'Вывод на экран экрана помощи', ;
  //                     'Настройка рабочего места', ;
  //                     'Установка кодов принтера', ;
  //                     'Переидексирование справочников НСИ в рабочем каталоге', ;
  //                     'Режим просмотра - кто находится в задаче и в каком режиме', ;
  //                     'Просмотр файла ошибок'})
  // // aadd(func_menu, {'file_Wordpad(exe_dir + cslash + 'README.RTF')', ;
  // aadd(func_menu, {'view_file_in_Viewer(exe_dir + cslash + 'README.RTF')', ;
  //                 'm_help()', ;
  //                 'nastr_rab_mesto()', ;
  //                 'ust_printer(T_ROW)', ;
  //                 'index_work_dir(exe_dir, cur_dir, .t.)', ;
  //                 'net_monitor(T_ROW, T_COL - 7, (hb_user_curUser:IsAdmin()))', ;
  //                 'view_errors()'})
  func_main(.t., blk_ekran)
  return NIL

// 25.05.13 подсчитать следующую позицию для главного меню задачи
Static Function cmain_next_pos(n)
  
  DEFAULT n TO 5
  return atail(cmain_menu) + len(atail(main_menu)) + n
