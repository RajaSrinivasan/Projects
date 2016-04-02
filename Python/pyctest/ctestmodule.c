#include <sys/stat.h>

#include <Python.h>

static PyObject *
ctest_system(PyObject *self, PyObject *args)
{
    const char *command;
    int sts;

    if (!PyArg_ParseTuple(args, "s", &command))
        return NULL;
    sts = system(command);
    return PyLong_FromLong(sts);
}

static PyObject *
ctest_file(PyObject *self, PyObject *args)
{
    const char *filename;

    if (!PyArg_ParseTuple(args, "s", &filename))
        return NULL;
    printf("Opening file %s\n" , filename);

    return PyLong_FromLong(0);
}

static PyObject *
ctest_filesize(PyObject *self, PyObject *args)
{
    const char *filename;
    struct stat filestat ;

    if (!PyArg_ParseTuple(args, "s", &filename))
        return NULL;
    stat( filename , &filestat ) ;

    printf("file %s size %lld\n" , filename, filestat.st_size );

    return PyLong_FromLong(filestat.st_size);
}


static PyObject *
ctest_checksize(PyObject *self, PyObject *args)
{
    const char *filename;
    struct stat filestat ;
    long compsize ;

    if (!PyArg_ParseTuple(args, "sl", &filename , &compsize ))
        return NULL;
    stat( filename , &filestat ) ;

    printf("file %s size %lld compare %ld\n" , filename, filestat.st_size , compsize);
    if (compsize == filestat.st_size)
    {
        return Py_True ;
    }
    else
    {
        return Py_False ;
    }
}


static PyMethodDef ctestMethods[] = {
    {"system",  ctest_system, METH_VARARGS,
     "Execute a shell command."},
     {"file",  ctest_file, METH_VARARGS,
      "Open a special file."},
      {"filesize",  ctest_filesize, METH_VARARGS,
       "Return the filesize."},
       {"checksize",  ctest_checksize, METH_VARARGS,
        "Compare the filesize."},
          {NULL, NULL, 0, NULL}        /* Sentinel */
};

static struct PyModuleDef ctestmodule = {
   PyModuleDef_HEAD_INIT,
   "ctest",   /* name of module */
   NULL, /* module documentation, may be NULL */
   -1,       /* size of per-interpreter state of the module,
                or -1 if the module keeps state in global variables. */
   ctestMethods
};

PyMODINIT_FUNC
PyInit_ctest(void)
{
    PyObject *m;
    printf("Initializing the module\n");
    m = PyModule_Create(&ctestmodule);
    return m;
}
