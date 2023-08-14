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
		exit(-1);
	}
	char buf[20];
	unsigned int col;
	unsigned int row;
	unsigned int range = 0;
	fscanf(fp, "%s %d %d %d", buf, &col, &row, &range);
	Image *image_array = (Image *) malloc(sizeof(Image));
	if (image_array == NULL) {
		printf("Memory allocation for image_array failed.");
		exit(-1);
	}
	image_array->image = (Color *) malloc(row * sizeof(Color*));
	for (int i = 0; i < row; i++) {
		image_array->image[i] = (Color *) malloc(col * sizeof(Color*));
	}
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			fscanf(fp, "%u %u %u", 
				&(image_array->image[i][j].R),
				&(image_array->image[i][j].G),
				&(image_array->image[i][j].B)
			);
		}
	}
	image_array->rows = row;
	image_array->cols = col;
	fclose(fp);
	return image_array;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n");
	printf("%u %u\n", image->cols, image->rows);
	int row = image->rows;
	int col = image->cols;
	printf("255\n");
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			Color temp = image->image[i][j];
			if (j != 0) {
				printf("   ");
			}
			printf("%3d %3d %3d", temp.R, temp.G, temp.B); 
		}
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	for (int i = 0; i < (image->rows); i++) {
		free(image->image[i]);
	}
	free(image->image);
	free(image);
}