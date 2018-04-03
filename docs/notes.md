
# NOTES

File created to store notes related to the development of the software.

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

## 02/04/2018


### Function vs. Subroutines

This is a follow-up to the Pure section above.

In Fortran there are 2 types of procedures. Functions and subroutines. Each one has its own characteristics. The following descriptions are summarized version of what is found in the [WikiBooks](https://en.wikibooks.org/wiki/Fortran/Fortran_procedures_and_functions) site.


#### Function

Functions are the same thing as in other languages. You define them, with or without parameters, and call them in the C fashion, `variable = func()`. In Fortran, functions only return one single value.

The parameters may, or may not, be modified inside the function. Usually defined using the `intent(in)` declaration. By default, parameters can be changed.

The return value can be explicited by declaring it in the function's signature:
```f90
function area(height, width) result(r)
	! intent(in) means it cannot be changed
	integer, intent(in) :: height
	integer, intent(in) :: width
	integer :: r

	r = height * width
end function area
```

Or, it can be a variable with same name as the function:
```f90
function area(height, width)
	integer, intent(in) :: height
	integer, intent(in) :: width
	integer :: area

	area = height * width
end function area
```

Note that the `intent` is not strictly necessary. But, some compilers require it to be declared. Matter of good practices, I suppose.


#### Subroutines

Subroutines are very similar to functions. But, instead of returning values, subroutines are only allowed to perform changes in the inputs of its arguments. They DO NOT RETURN.

Another difference is how to invoke/call said subroutines. If in functions we use C like notation, `func()`, for subroutines we use a similar, but different one. `call subr()`.

The notation is similar with the function:
```f90
subroutine increment(i, amount)
	integer, intent(in) :: amount
	integer, intent(inout) :: i
	i = i + amount
end subroutine increment
```


### Main

When using the RET.tar input provided by the teacher, the `driver` parameter, defined in [parameters.f](../dynemol/parameters.f), is `slice_A0`. This makes the program run into [AO_adiabatic.f](../dynemol/AO_adiabatic.f).

In the `AO_adiabatic.f` we can see the main loop of the application. Line 100. The loop is called to calculate the state of the universe in the time frame provided. We see that the **Ehrenfest** function is called in it.
