#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#if defined(__APPLE__) && defined(__MACH__)
#include <Accelerate/Accelerate.h>

//---------------------------------------------------------------------
double SquaredEuclideanDistance(const double *vectorA, const double *vectorB, size_t count) {
    double result = 0.0;
    double *diff = (double *)malloc(count * sizeof(double));

    vDSP_vsubD(vectorB, 1, vectorA, 1, diff, 1, count);
    vDSP_svesqD(diff, 1, &result, count);

    free(diff);
    return result;
}

//---------------------------------------------------------------------
double EuclideanDistance(const double *vectorA, const double *vectorB, size_t count) {
    double squaredDistance = SquaredEuclideanDistance(vectorA, vectorB, count);
    return sqrt(squaredDistance);
}

//---------------------------------------------------------------------
double DotProduct(const double *vectorA, const double *vectorB, size_t count) {
    double result = 0.0;
    vDSP_dotprD(vectorA, 1, vectorB, 1, &result, count);
    return result;
}

//---------------------------------------------------------------------
double CosineDistance(const double *vectorA, const double *vectorB, size_t count) {
    double dotProduct = 0.0;
    vDSP_dotprD(vectorA, 1, vectorB, 1, &dotProduct, count);

    double normA = 0.0;
    double normB = 0.0;
    vDSP_svesqD(vectorA, 1, &normA, count);
    vDSP_svesqD(vectorB, 1, &normB, count);

    normA = sqrt(normA);
    normB = sqrt(normB);

    if (normA == 0.0 || normB == 0.0) {
        return NAN;
    }

    return 1.0 - (dotProduct / (normA * normB));
}

//---------------------------------------------------------------------
double VectorNorm(const double *vector, size_t count, const char *type) {
    double result = 0.0;

    if (strcmp(type, "1") == 0) {
        vDSP_svemgD(vector, 1, &result, count);
    } else if (strcmp(type, "infinity") == 0 || strcmp(type, "max") == 0) {
        vDSP_maxmgvD(vector, 1, &result, count);
    } else if (strcmp(type, "2") == 0 || strcmp(type, "euclidean") == 0) {
        vDSP_svesqD(vector, 1, &result, count);
        result = sqrt(result);
    } else {
        // Invalid norm type, return NaN
        result = NAN;
    }

    return result;
}
#else

double SquaredEuclideanDistance(const double *vectorA, const double *vectorB, size_t count) {
    printf("This program requires macOS and the Accelerate framework.\n");
    return 0;
}
double EuclideanDistance(const double *vectorA, const double *vectorB, size_t count) {
    printf("This program requires macOS and the Accelerate framework.\n");
    return 0;
}
double DotProduct(const double *vectorA, const double *vectorB, size_t count) {
    printf("This program requires macOS and the Accelerate framework.\n");
    return 0;
}
double CosineDistance(const double *vectorA, const double *vectorB, size_t count) {
    printf("This program requires macOS and the Accelerate framework.\n");
    return 0;
}
#endif