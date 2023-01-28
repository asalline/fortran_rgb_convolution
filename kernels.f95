module kernels
    implicit none

    contains

        !!! Function to choose which kind of 3x3 kernel matrix user wants to use.
        subroutine kernel_matrices(operation, kernel_size, kernel_matrix)
            implicit none

            ! Variables
            character (len = *), intent(in) :: operation
            integer, intent(out) :: kernel_size
            double precision, dimension(:,:), allocatable, intent(out) :: kernel_matrix

            intrinsic transpose, reshape

            ! List of choosable matrices
            if (operation == 'identity' .or. operation == '1') then
                allocate(kernel_matrix(3,3))
                kernel_matrix = transpose(reshape((/ 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0 /), shape(kernel_matrix)))
                kernel_size = 3
            else if (operation == 'edge detection' .or. operation == '2') then
                allocate(kernel_matrix(3,3))
                kernel_matrix = transpose(reshape((/-1, -1, -1, -1, 8, -1, -1, -1, -1 /), shape(kernel_matrix)))
                kernel_size = 3
            else if (operation == 'sharpen' .or. operation == '3') then
                allocate(kernel_matrix(3,3))
                kernel_matrix = transpose(reshape((/ 0, -1, 0, -1, 5, -1, 0, -1, 0 /), shape(kernel_matrix)))
                kernel_size = 3
            else if (operation == 'box blur' .or. operation == '4') then
                allocate(kernel_matrix(3,3))
                kernel_matrix = transpose(reshape((/ 1, 1, 1, 1, 1, 1, 1, 1, 1 /), shape(kernel_matrix)))
                kernel_matrix = 0.1111 * kernel_matrix
                kernel_size = 3
            else if (operation == 'Gaussian blur' .or. operation == '5') then
                allocate(kernel_matrix(3,3))
                kernel_matrix = transpose(reshape((/ 1, 2, 1, 2, 4, 2, 1, 2, 1 /), shape(kernel_matrix)))
                kernel_matrix = 0.0625 * kernel_matrix
                kernel_size = 3
            else if (operation == 'Gaussian blur 5x5' .or. operation == '6') then
                allocate(kernel_matrix(5,5))
                kernel_matrix = transpose(reshape((/ 1, 4, 6, 4, 1, 4, 16, 24, 16, 4, 6, 24, 36, 24, 6, 4, 16, 24, 16, &
                                                    & 4, 1, 4, 6, 4, 1 /), shape(kernel_matrix)))
                kernel_matrix = 0.00390625 * kernel_matrix
                kernel_size = 5
            else if (operation == 'Sobel x' .or. operation == '7') then
                allocate(kernel_matrix(3,3))
                kernel_matrix = transpose(reshape((/ 1, 0, -1, 2, 0, -2, 1, 0, -1 /), shape(kernel_matrix)))
                kernel_size = 3
            else if (operation == 'Sobel y' .or. operation == '8') then
                allocate(kernel_matrix(3,3))
                kernel_matrix = transpose(reshape((/ 1, 2, 1, 0, 0, 0, -1, -2, -1 /), shape(kernel_matrix)))
                kernel_size = 3
            end if

        end subroutine kernel_matrices

        !!! Function to calculate target size of convolved image
        !!! (which is smaller than original image)
        function target_size(dim1, dim2, kernel_size)
            implicit none

            ! Variables
            integer, intent(in) :: dim1, dim2, kernel_size
            integer :: added1, added2, i, j
            integer, dimension(2) :: target_size

            target_size = 0
            
            ! Calculating the first target size (rows)
            do i = 1, dim1
                added1 = i + kernel_size
                if (added1 <= dim1) then
                    target_size(1) = target_size(1) + 1
                end if
            end do

            ! Calculating the second target size (columns)
            do j = 1, dim2
                added2 = j + kernel_size
                if (added2 <= dim2) then
                    target_size(2) = target_size(2) + 1
                end if
            end do

        end function target_size

end module kernels
