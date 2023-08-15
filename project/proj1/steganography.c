/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	Color color;
	Color *new_color = (Color *) malloc(sizeof(Color));
	uint8_t blue_value ;
	blue_value = image->image[row][col].B;
	uint8_t value = 0x1 & blue_value;
	if (value == 0) {
		new_color->R = 0;
		new_color->G = 0;
		new_color->B = 0;
	} else {
		new_color->R = 255;
		new_color->G = 255;
		new_color->B = 255;
	}
	return new_color;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	uint32_t row = image->rows;
	uint32_t col = image->cols;
	Image *new_image = (Image *) malloc(sizeof(Image));
	new_image->image = (Color *) malloc(row * sizeof(Color*));
	for (int i = 0; i < row; i++) {
		new_image->image[i] = (Color *) malloc(col * sizeof(Color*));
	}
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			Color *temp = evaluateOnePixel(image, i, j);
			new_image->image[i][j] = *temp;
			free(temp);
		}
	}
	new_image->cols = image->cols;
	new_image->rows = image->rows;
	return new_image;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if (argc != 2) {
		printf("usage: %s filename\n", argv[0]);
		exit(-1) ;
	}
	char *filename = argv[1];
	Image *original_image = readData(filename);
	Image *new_image = steganography(original_image);
	writeData(new_image);
	freeImage(new_image) ;
	freeImage(original_image);
}
