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


static PyMethodDef ctestMethods[] = {
    {"system",  ctest_system, METH_VARARGS,
     "Execute a shell command."},
     {"file",  ctest_file, METH_VARARGS,
      "Open a special file."},
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
