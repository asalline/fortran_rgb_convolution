!!! Program to convolve 2d-image with different kernels.
!!! Used with Python scripts "img_to_matrix.py" and "mat_to_image.py".
!!! First one converts chosen image to matrix and saves it as .txt-file
!!! and after that one runs this program. After calculations one converts
!!! the convolved matrix back to image.

program rgb_conv2d
    use kernels
    implicit none

    ! Variables
    character (len = 50) :: operation, image_name, firstline
    character (len = 100) :: red_name, green_name, blue_name
    character (len = 8), dimension(3) :: colors
    integer :: dim1, dim2, kernel_size
    integer, dimension(2) :: target_size1
    double precision, dimension(:,:), allocatable :: kernel_matrix, conv_image
    double precision, dimension(:,:), allocatable :: red_conv_image, green_conv_image, blue_conv_image, red_image, green_image, &
                                                    & blue_image, s_x, s_y, s_xy, red_conv_image_x, red_conv_image_y, &
                                                    & green_conv_image_x, green_conv_image_y, blue_conv_image_x, &
                                                    & blue_conv_image_y, discriminant, eigenvalue1

    intrinsic transpose, sum, atan2

    colors = [character(len=8) :: 'red_', 'green_', 'blue_']

    !Choosing the kernel for the convolution. All kernels are size of 3x3.
    write(*, '(A)') 'Available operations are: "identity" = 1, "edge detection" = 2, "sharpen" = 3, "box blur" = 4, & 
                    & "Gaussian blur" = 5, "Gaussian blur 5x5" = 6, "Sobel x" = 7, "Sobel y" = 8'
    write(*, *) ' '
    write(*, '(A)') 'Choose an operation: '
    read(*,*) operation
    print *, ''

    ! Calling function from the module "kernels".
    call kernel_matrices(operation, kernel_size, kernel_matrix)

    ! Writing the kernel to show its values by calling subroutine from the
    ! module "matrix_module".
    write(*, '(A)') 'The chosen kernel matrix is = '
    call print_matrix(kernel_matrix)
    print *, ''
    ! kernel_matrix = 0.75 * kernel_matrix

    !!! Choosing the image as a .txt-file from the folder. Text-file must
    !!! have to be such that first line contains dimension of the image
    !!! and lines below are the values of the image-matrix.
    write(*, '(A)') 'Choose the image from the folder: '
    read(*,*) image_name

    red_name = trim(colors(1)) // trim(image_name)
    green_name = trim(colors(2)) // trim(image_name)
    blue_name = trim(colors(3)) // trim(image_name)

    ! image_name = i // image_name
    ! Reading the first line to get dimension of the image.
    open(10, file = red_name)
    read(10, *) dim1, dim2

    allocate(red_image(dim1, dim2), green_image(dim1, dim2), blue_image(dim1, dim2)) !, &
            ! & S_x(dim1, dim2), S_y(dim1, dim2), S_xy(dim1, dim2))

    ! Reading the rest of lines to get the image as a matrix.
    open(10, file = red_name)
    read(10, *) red_image
    close(10)

    open(10, file = green_name)
    read(10, *) firstline
    read(10, *) green_image
    close(10)

    open(10, file = blue_name)
    read(10, *) firstline
    read(10, *) blue_image
    close(10)

    target_size1 = target_size(dim1, dim2, kernel_size)
    
    allocate(red_conv_image(target_size1(2), target_size1(1)), green_conv_image(target_size1(2), target_size1(1)), &
            & blue_conv_image(target_size1(2), target_size1(1)), discriminant(target_size1(2), target_size1(1)), & 
            & eigenvalue1(target_size1(2), target_size1(1)), s_x(target_size1(2), target_size1(1)), &
            & s_y(target_size1(2), target_size1(1)), s_xy(target_size1(2), target_size1(1)), & 
            & conv_image(target_size1(2), target_size1(1)))

    if (operation == 'edge detection' .or. operation == '2') then
        red_image = red_image / 255
        green_image = green_image / 255
        blue_image = blue_image / 255

        allocate(red_conv_image_x(target_size1(2), target_size1(1)), red_conv_image_y(target_size1(2), target_size1(1)), &
                & green_conv_image_x(target_size1(2), target_size1(1)), green_conv_image_y(target_size1(2), target_size1(1)), &
                & blue_conv_image_x(target_size1(2), target_size1(1)), blue_conv_image_y(target_size1(2), target_size1(1)))

        call kernel_matrices('7', kernel_size, kernel_matrix)
        red_conv_image_x = real_conv(kernel_matrix, kernel_size, red_image, dim1, dim2, target_size1)
        green_conv_image_x = real_conv(kernel_matrix, kernel_size, green_image, dim1, dim2, target_size1)
        blue_conv_image_x = real_conv(kernel_matrix, kernel_size, blue_image, dim1, dim2, target_size1)

        s_x = red_conv_image_x * red_conv_image_x + green_conv_image_x * green_conv_image_x + &
                & blue_conv_image_x * blue_conv_image_x
        
        call kernel_matrices('8', kernel_size, kernel_matrix)
        red_conv_image_y = real_conv(kernel_matrix, kernel_size, red_image, dim1, dim2, target_size1)
        green_conv_image_y = real_conv(kernel_matrix, kernel_size, green_image, dim1, dim2, target_size1)
        blue_conv_image_y = real_conv(kernel_matrix, kernel_size, blue_image, dim1, dim2, target_size1)

        s_y = red_conv_image_y * red_conv_image_y + green_conv_image_y * green_conv_image_y + &
                & blue_conv_image_y * blue_conv_image_y

        s_xy = red_conv_image_x * red_conv_image_y + green_conv_image_x * green_conv_image_y + &
                & blue_conv_image_x * blue_conv_image_y

        discriminant = sqrt(abs(s_x * s_x - 2 * s_x * s_y + s_y * s_y + 4 * s_xy * s_xy))
        eigenvalue1 = (s_x + s_y + discriminant) / 2

        eigenvalue1 = sqrt(eigenvalue1) * 255

        ! call print_matrix(eigenvalue1)

        conv_image = atan2(-s_xy, eigenvalue1 - s_y) * 255

        ! Save the matrix as .txt-file.
        open(12, file = 'convolved_image.txt', status = 'replace', action = 'write')
        write(12, *) target_size1(1), ':',  target_size1(2)
        write(12, *) transpose(eigenvalue1)
        close(12)

        ! call print_matrix(conv_image)
        
    else

        ! Convolving happens here.
        red_conv_image = real_conv(kernel_matrix, kernel_size, red_image, dim1, dim2, target_size1)
        green_conv_image = real_conv(kernel_matrix, kernel_size, green_image, dim1, dim2, target_size1)
        blue_conv_image = real_conv(kernel_matrix, kernel_size, blue_image, dim1, dim2, target_size1)

    end if

    ! Save the matrix as .txt-file.
    open(12, file = 'red_convolved_image.txt', status = 'replace', action = 'write')
    write(12, *) target_size1(1), ':',  target_size1(2)
    write(12, *) transpose(red_conv_image)
    close(12)

    open(12, file = 'green_convolved_image.txt', status = 'replace', action = 'write')
    write(12, *) target_size1(1), ':',  target_size1(2)
    write(12, *) transpose(green_conv_image)
    close(12)

    open(12, file = 'blue_convolved_image.txt', status = 'replace', action = 'write')
    write(12, *) target_size1(1), ':',  target_size1(2)
    write(12, *) transpose(blue_conv_image)
    close(12)
    

    contains

        function real_conv(kernel_matrix, kernel_size, image, dim1, dim2, target_size) result(conv_image)
            implicit none

            ! Variables
            integer :: i, j
            integer, intent(in) :: kernel_size, dim1, dim2
            integer, dimension(2), intent(in) :: target_size
            double precision, dimension(dim1, dim2), intent(in) :: image
            double precision, dimension(kernel_size, kernel_size), intent(in) :: kernel_matrix
            double precision, dimension(kernel_size, kernel_size) :: to_conv
            double precision, dimension(target_size(1), target_size(2)) :: conv_image

            ! Convolution routine.
            do i = 1, target_size(1)
                do j = 1, target_size(2)
                    to_conv = image(i:i + kernel_size, j:j + kernel_size)
                    to_conv = transpose(to_conv)
                    conv_image(i, j) = sum(to_conv * kernel_matrix)
                end do
            end do

        end function real_conv

        !!! Subroutine to print a given matrix.
        subroutine print_matrix(matrix)
            implicit none

            double precision, dimension(:,:) :: matrix
            integer :: dim1, dim2, i ,j
            intrinsic size

            dim1 = size(matrix, dim = 1)
            dim2 = size(matrix, dim = 2)

            do i = 1, dim1
                do j = 1, dim2
                    write(*, '(f10.5)', advance = 'no') matrix(i,j)
                end do
                write(*,*)
            end do

        end subroutine print_matrix

end program rgb_conv2d

!!! TO COMPILE, RUN
! gfortran -c kernels.f95 conv2d.f95
! gfortran kernels.o conv2d.o
! ./a.out
