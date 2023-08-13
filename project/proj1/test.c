#include <stdio.h>
int main() {
    char buf[20];
    int x;
    int y;
    char *s = "testInputs/blinkerV.ppm";
    FILE *fp = fopen(s, "r");
    if (fp == NULL) {
        printf("open file %s error", s);
    }
    printf("test of s: %s\n", s);
    int range;
    fscanf(fp, "%s %d %d %d", buf, &x, &y, &range);
    printf("x: %d, y: %d, range: %d\n", x, y, range);
    for (int i = 0; i < x; i++) {
        int r, g, b;
        for (int j = 0; j < y; j++) {
            fscanf(fp, "%d %d %d", &r, &g, &b);
            printf("%3d%3d%3d\n", r, g, b);
        }
    }
    fclose(fp);
}