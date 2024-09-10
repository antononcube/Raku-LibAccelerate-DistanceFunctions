#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#if defined(__APPLE__) && defined(__MACH__)
//=====================================================================
// ACCELERATE
//=====================================================================
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
//=====================================================================
// GENERIC
//=====================================================================
double SquaredEuclideanDistance(double *a, double *b, int n) {
    double sum = 0.0;
    for (int i = 0; i < n; i++) {
        double diff = a[i] - b[i];
        sum += diff * diff;
    }
    return sum;
}

//---------------------------------------------------------------------
double EuclideanDistance(double *a, double *b, int n) {
    double squaredDistance = SquaredEuclideanDistance(a, b, n);
    return sqrt(squaredDistance);
}

//---------------------------------------------------------------------
double DotProduct(double *a, double *b, int n) {
    double dot_product = 0.0;
    for (int i = 0; i < n; i++) {
        dot_product += a[i] * b[i];
    }
    return dot_product;
}

//---------------------------------------------------------------------
double CosineDistance(double *a, double *b, int n) {
    double dot_product = 0.0, norm_a = 0.0, norm_b = 0.0;
    for (int i = 0; i < n; i++) {
        dot_product += a[i] * b[i];
        norm_a += a[i] * a[i];
        norm_b += b[i] * b[i];
    }
    if (norm_a == 0.0 || norm_b == 0.0) {
        return 1.0;
    }
    return 1.0 - (dot_product / (sqrt(norm_a) * sqrt(norm_b)));
}

//---------------------------------------------------------------------
double VectorNorm(double *vec, int length, const char *type) {
    double norm = 0.0;

    if (strcmp(type, "1") == 0) {
        for (int i = 0; i < length; i++) {
            norm += fabs(vec[i]);
        }
    } else if (strcmp(type, "infinity") == 0 || strcmp(type, "max") == 0) {
        for (int i = 0; i < length; i++) {
            if (fabs(vec[i]) > norm) {
                norm = fabs(vec[i]);
            }
        }
    } else if (strcmp(type, "2") == 0 || strcmp(type, "euclidean") == 0) {
        for (int i = 0; i < length; i++) {
            norm += vec[i] * vec[i];
        }
        norm = sqrt(norm);
    } else {
        fprintf(stderr, "Unknown norm type: %s\n", type);
        exit(EXIT_FAILURE);
    }

    return norm;
}

#endif