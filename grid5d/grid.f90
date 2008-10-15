!>\brief  classe per la gestione di volumi di dati regolari (gridded)
!!
!!Questo modulo definisce gli oggetti e i metodi per gestire
!!l'importazione e l'esportazione di volumi regolari (gridded) 
!!e della loro gestione nei sistemi di coordinate geografiche e proiezioni


module grid_class

use regular_ll_class
use rotated_ll_class
use log4fortran

implicit none


character (len=255),parameter:: subcategory="grid_class"

type grid_type

  character(len=80) :: type

end type grid_type


!>\brief definizione del grigliato in genere
type grid_def

  private

  type(grid_type)   :: type
  type(grid_regular_ll) :: regular_ll
  type(grid_rotated_ll) :: rotated_ll

  integer :: category !< log4fortran

end type grid_def


INTERFACE init
  MODULE PROCEDURE init_grid
END INTERFACE

INTERFACE delete
  MODULE PROCEDURE delete_grid
END INTERFACE

INTERFACE get_val
  MODULE PROCEDURE get_val_grid
END INTERFACE


private

public grids_proj,grids_unproj,grid_def,grid_dim,init,delete,get_val

contains



subroutine init_grid(this,dim,type,&
 nx,ny, &
 lon_min, lon_max, lat_min, lat_max, component_flag, &
 latitude_south_pole,longitude_south_pole,angle_rotation, &
 categoryappend)

type(grid_def) :: this
type(grid_dim) :: dim

character(len=*),INTENT(in),OPTIONAL :: type
integer,optional :: nx, ny
doubleprecision,optional :: lon_min, lon_max, lat_min, lat_max
doubleprecision,optional :: latitude_south_pole,longitude_south_pole,angle_rotation
integer,optional :: component_flag

character(len=*),INTENT(in),OPTIONAL :: categoryappend !< appennde questo suffisso al namespace category di log4fortran

character(len=512) :: a_name


call l4f_launcher(a_name,a_name_append=trim(subcategory)//"."//trim(categoryappend))
this%category=l4f_category_get(a_name)

if (present(type))then
  this%type%type=type
else
  this%type%type=cmiss
  return
end if


call l4f_category_log(this%category,L4F_DEBUG,"init gtype: "//this%type%type )

select case ( this%type%type)

case ( "regular_ll")
  call init(this%regular_ll,dim,&
   nx,ny, &
   lon_min, lon_max, lat_min, lat_max, component_flag, &
   categoryappend=trim(subcategory)//"."//trim(categoryappend))

case ( "rotated_ll")
  call init(this%rotated_ll,dim,&
   nx,ny, &
   lon_min, lon_max, lat_min, lat_max, component_flag, &
   latitude_south_pole,longitude_south_pole,angle_rotation, &
   categoryappend=trim(subcategory)//"."//trim(categoryappend))
  
case default
  call l4f_category_log(this%category,L4F_ERROR,"gtype: "//this%type%type//" non gestita" )
  call exit (1)

end select


end subroutine init_grid


subroutine delete_grid(this,dim)
type(grid_def) :: this
type(grid_dim) :: dim

select case ( this%type%type)

case ( "regular_ll")
  call delete(this%regular_ll,dim)

case ( "rotated_ll")
  call delete(this%rotated_ll,dim)
  
case default
  call l4f_category_log(this%category,L4F_ERROR,"gtype: "//this%type%type//" non gestita" )
  call exit (1)

end select

!chiudo il logger
call l4f_category_delete(this%category)


end subroutine delete_grid




subroutine grids_proj (this,dim)

type(grid_def) :: this
type(grid_dim) :: dim

select case ( this%type%type)

case ( "regular_ll")
  call grid_proj(this%regular_ll,dim)

case ( "rotated_ll")
  call grid_proj(this%rotated_ll,dim)
  
case default
  call l4f_category_log(this%category,L4F_ERROR,"gtype: "//this%type%type//" non gestita" )
  call exit (1)

end select

end subroutine grids_proj


subroutine grids_unproj (this,dim)

type(grid_def) ::this
type(grid_dim) :: dim

select case ( this%type%type)

case ( "regular_ll")
  call grid_unproj(this%regular_ll, dim)

case ( "rotated_ll")
  call grid_unproj(this%rotated_ll, dim)

case default
  call l4f_category_log(this%category,L4F_ERROR,"gtype: "//this%type%type//" non gestita" )
  call exit (1)

end select

end subroutine grids_unproj


subroutine get_val_grid(this,dim,type,&
 nx,ny, &
 lon_min, lon_max, lat_min, lat_max, component_flag, &
 latitude_south_pole,longitude_south_pole,angle_rotation)

type(grid_def) :: this
type(grid_dim) :: dim

character(len=*),INTENT(out),OPTIONAL :: type
integer,optional,intent(out) :: nx, ny
doubleprecision,optional,intent(out) :: lon_min, lon_max, lat_min, lat_max
doubleprecision,optional,intent(out) :: latitude_south_pole,longitude_south_pole,angle_rotation
integer,optional,intent(out) :: component_flag

if (present(type)) type = this%type%type

select case ( this%type%type)

case ( "regular_ll")
  call get_val(this%regular_ll,dim,&
   nx,ny, &
   lon_min, lon_max, lat_min, lat_max, component_flag)

case ( "rotated_ll")
  call get_val(this%rotated_ll,dim,&
   nx,ny, &
   lon_min, lon_max, lat_min, lat_max, component_flag, &
   latitude_south_pole,longitude_south_pole,angle_rotation)
  
case default
  call l4f_category_log(this%category,L4F_ERROR,"gtype: "//this%type%type//" non gestita" )
  call exit (1)

end select


end subroutine get_val_grid


end module grid_class



