/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <stdint.h>
#include <stdio.h>
#include <jpeglib.h>

int main(int argc, char *argv[])
{
    int test_boolean;
    int32_t test_int32;
    struct jpeg_decompress_struct cinfo;

    (void)argc;
    (void)argv;

    test_boolean = 1;
    test_int32 = 1;
    (void)test_boolean;
    (void)test_int32;

    jpeg_create_decompress(&cinfo);
    jpeg_destroy_decompress(&cinfo);

    return 0;
}
