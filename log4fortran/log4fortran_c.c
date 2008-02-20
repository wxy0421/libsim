#include "stdio.h"
#include "log4c.h"
#include "f77.h"




F77_INTEGER_FUNCTION(log4fortran_init)() {
  return log4c_init();
}

F77_POINTER_FUNCTION(log4fortran_category_get)(CHARACTER(a_name) TRAIL(a_name)) {

  void *tmpptr;
  char ptr_a_name[101];

  GENPTR_CHARACTER(a_name)
  cnfImprt(a_name, a_name_length > 100 ? 100:a_name_length, ptr_a_name);

  tmpptr = log4c_category_get(ptr_a_name);
  if (cnfRegp(tmpptr) == 1)
    return cnfFptr(tmpptr);
  else
    return 0;
}


F77_SUBROUTINE(log4fortran_category_delete)(POINTER(a_category)){

  GENPTR_POINTER(a_category)
  
  cnfUregp(cnfCptr(*a_category));

}


F77_SUBROUTINE(log4fortran_category_log)(POINTER(a_category), 
					 INTEGER(a_priority),
					 CHARACTER(a_format) TRAIL(a_format)) {
  char ptr_a_format[101];

  GENPTR_POINTER(a_category)
  GENPTR_INTEGER(a_priority)
  GENPTR_CHARACTER(a_format)

  cnfImprt(a_format, a_format_length > 100 ? 100:a_format_length, ptr_a_format);
  log4c_category_log(cnfCptr(*a_category), *a_priority, ptr_a_format);

}


F77_INTEGER_FUNCTION(log4fortran_fini)() {
  return log4c_fini();
}