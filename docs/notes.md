
# NOTES

File created to store notes related to the development of the sofware.

---

## 29/03/2018

### PURE procedures

Pure procedures are procedures that, according to this Lahey [link](http://www.lahey.com/docs/lfenthelp/F95ARPURE.htm):

> there is no chance that the procedure would have any side effect on data outside the procedure.

And this IBM [link](https://www.ibm.com/support/knowledgecenter/SSGH4D_13.1.0/com.ibm.xlf131.aix.doc/language_ref/pure.html):

> Pure procedures are free of side effects and are particularly useful in FORALL statements and constructs, which by design require that all referenced procedures be free of side effects.

So, it seems that these kind of procedures are used with very specific cases. No input of the procedure may be altered. In true, all of them must be declared with `intent(in)` making them inalterable in compile time.

According to this StackOverflow [answer](https://stackoverflow.com/a/30315370):

> PURE is required in some cases - for example, procedures called within specification expressions or from FORALL or DO CONCURRENT constructs. PURE is required in these case to give the Fortran processor flexibility in the ordering of procedure invocations while still having a reasonably deterministic outcome from a particular stretch of code.

In conclusion, this keyword guarantees determinism while giving the compiler a little bit of space to perform some *out of order* processing (I think).

With this said, I can se why OpenMP directives may not be called from pure functions. The determinism goes away when adding threads, makes sense to have this limitation to avoid breaking everything up.

---
