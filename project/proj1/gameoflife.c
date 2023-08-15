/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

int row_bias[8] = {-1, -1, -1, 0, 0, 1, 1, 1};
int col_bias[8] = {-1, 0, 1, -1, 1, -1, 0, 1};

int get_neighbor_index(int original, int module) {
	return (original + module) % module;
}

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	Color *new_color = (Color *)malloc(sizeof(Color));
	int is_alive_R, is_alive_G, is_alive_B;
	int r_alive_neighbor = 0, g_alive_neighbor = 0, b_alive_neighbor = 0;
	int shift_bias_R, shift_bias_G, shift_bias_B;

	is_alive_R = ((image->image[row][col].R) == 255);
	is_alive_G = ((image->image[row][col].G) == 255);
	is_alive_B = ((image->image[row][col].B) == 255);

	for (int i = 0; i < 8; i++) {
		int neigh_row = get_neighbor_index(row + row_bias[i], image->rows);
		int neigh_col = get_neighbor_index(col + col_bias[i], image->cols);
		Color curr_neigh = image->image[neigh_row][neigh_col];
		if (curr_neigh.R == 255) {
			r_alive_neighbor++;
		}
		if (curr_neigh.G == 255) {
			g_alive_neighbor++;
		}
		if (curr_neigh.B == 255) {
			b_alive_neighbor++;
		}
	}

	shift_bias_R = 9 * is_alive_R + r_alive_neighbor;
	shift_bias_G = 9 * is_alive_G + g_alive_neighbor;
	shift_bias_B = 9 * is_alive_B + b_alive_neighbor;

	if (rule & (1 << shift_bias_R)) {
		new_color->R = 255;
	} else {
		new_color->R = 0;
	}
	if (rule & (1 << shift_bias_G)) {
		new_color->G = 255;
	} else {
		new_color->G = 0;
	}
	if (rule & (1 << shift_bias_B)) {
		new_color->B = 255;
	} else {
		new_color->B = 0;
	}
	return new_color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	uint32_t row = image->rows;
	uint32_t col = image->cols;
	Image *new_image = (Image*)malloc(sizeof(Image));
	new_image->image = (Color**)malloc(row * sizeof(Color*));
	for (int i = 0; i < row; i++) {
		new_image->image[i] = (Color *) malloc(col * sizeof(Color*));
	}
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			Color *temp = evaluateOneCell(image, i, j, rule);
			new_image->image[i][j] = *temp;
			free(temp);
		}
	}
	new_image->rows = image->rows;
	new_image->cols = image->cols;
	return new_image;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if (argc != 3) {
		printf("usage: ./gameoflie filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\ 
    		\nrule is a hex number beginning with 0x\\; Life is 0x1808.");
		exit(-1);
	}
	char *filename = argv[1];
	char *endptr;
	char *rule =argv[2];
	uint32_t rule_value = strtol(rule, &endptr, 16);
	Image *original_image = readData(filename);
	Image *new_image = life(original_image, rule);
	writeData(new_image);
	freeImage(new_image);
	freeImage(original_image);
}
