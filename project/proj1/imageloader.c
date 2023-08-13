/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE *fp = fopen(filename, "r");
	if (fp == NULL) {
		printf("Could not open %s\n", filename);
		exit(1);
	}
	char buf[20];
	// int col = 0;
	// int row = 0;
	u_int32_t *col = (u_int32_t*) malloc(sizeof(u_int32_t));
	u_int32_t *row = (u_int32_t*) malloc(sizeof(u_int32_t));
	unsigned int range = 0;
	fscanf(fp, "%s %d %d %d", buf, col, row, &range);
	//printf("It is in the file imageloader.c\n row: %d, col: %d\n", *row, *col);
	Image *image_array = (Image *) malloc(sizeof(Image));
	if (image_array == NULL) {
		printf("Memory allocation for image_array failed.");
		exit(1);
	}
	Color *color_array = (Color *) malloc((*row) * (*col) * sizeof (Color));
	for (int i = 0; i < (*row); i++) {
		for (int j = 0; j < (*col); j++) {
			int index = i * (*col) + j;
			fscanf(fp, "%u %u %u", 
				&color_array[index].R, 
				&color_array[index].G,
				&color_array[index].B
			);
			//printf("index[%d], R: %u, G: %u, B: %u\n", index, color_array[index].R, color_array[index].G, color_array[index].B);
		}
	}
	image_array->image = color_array;
	image_array->rows = *row;
	//printf("current image_array->rows: %d\n", image_array->rows);
	image_array->cols = *col;
	//printf("current image_array->cols: %d\n", image_array->cols);
	fclose(fp);
	return image_array;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n");
	printf("%u %u\n", (unsigned int)image->cols, (unsigned int)image->rows);
	int row = image->rows;
	int col = image->cols;
	printf("255");
	int index;
	Color *color = image->image;
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			index = i * col + j;
			if (index % col == 0) {
				printf("\n");
			}
			if (index % col != 0) {
				printf("   ");
			}
			printf("%3d %3d %3d", color[index].R, color[index].G, color[index].B);
		}
	}
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
}