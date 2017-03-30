/*
 * File:   dclxvi-20130329/mydouble.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef MYDOUBLE_H
#define MYDOUBLE_H

#ifdef CHECK
#include "checkdouble.h"
#define mydouble CheckDouble
#else
#define mydouble double
#define setmax(x, y)
#define todouble(x) x
double remround(double a, double d);
#endif

#endif
