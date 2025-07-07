<h1 align="center">
    🎭 Re-Patchright
</h1>

This little project was created because I wanted to do things like this in my [patched Browser Use version](https://github.com/imamousenotacat/re-browser-use):

![nopecha_cloudflare.py](https://github.com/user-attachments/assets/2f16e2b4-9cef-4b4a-aa2d-e6ebf039cd14)

and I developed a logic there in [Browser Use](https://github.com/imamousenotacat/re-browser-use) that, combined which some modifications here, in this project, and in [re-patchright-python](https://github.com/imamousenotacat/re-patchright-python), makes possible some use cases that are still not available with the current (07/07/2025) *"regular"* patchright and browser-use versions ...

For more details in this check [re-browser-use](https://github.com/imamousenotacat/re-browser-use) repository.

# Quick start

Install the package using pip (according to [this](https://playwright.dev/python/docs/intro#system-requirements) you need Python>=3.8):

```bash
pip install re-patchright
```

Install the browser (I'm using chromium here):

```bash
re-patchright install chromium --with-deps
```

Run the example programs:

```bash
py examples/nopecha_cloudflare.py
```

You will get for this one something similar to what the animated gif above displays but without coloured rectangles.

```bash
py examples/armasPalpueblo.py
```

You will get for this one (I owe the strange file name to a Mexican friend of mine with peculiar musical taste 🙂) an output like this:

```bash
λ py examples\armasPalPueblo.py
ARMAS-PAL-PUEBLO 0: Found 120 children ...
ARMAS-PAL-PUEBLO 1: Found 2 children HEAD and BODY the two elements of the Document in the iframe ...
ARMAS-PAL-PUEBLO 2: Found 2 children ...
ARMAS-PAL-PUEBLO 3: Found 2 children ...
ARMAS-PAL-PUEBLO 4: Found 120 children ...
ARMAS-PAL-PUEBLO 5: Found 2 children ...
ARMAS-PAL-PUEBLO 6: Found children_count=[4] SHOULD BE EQUAL TO len(children)=[4] ...
ARMAS-PAL-PUEBLO 7: Found children_count=[4] SHOULD BE EQUAL TO len(children)=[4] ...

--- Starting Manual Recursive Search in Frame (Python API) ---
Checking: <BODY>
 Found 4 children for <BODY>
  Checking: <STYLE>
   Found 0 children for <STYLE>
  Checking: <DIV.main-wrapper..KlAp8.theme-light.size-normal.lang-en-us>
   Found 1 children for <DIV>
    Checking: <DIV#content>
     Found 8 children for <DIV#content>
      Checking: <DIV#NMOK7>
       Found 1 children for <DIV#NMOK7>
        Checking: <DIV.cb-c>
         Found 1 children for <DIV>
          Checking: <LABEL.cb-lb>
           Found 3 children for <LABEL>
            Checking: <INPUT[type=checkbox]>
            >>> Found checkbox locator: <Locator frame=<Frame name= url='https://nopecha.com/demo/cloudflare'> selector="iframe[src^='https://challenges.cloudflare.com/cdn-cgi/challenge-platform'] >> internal:control=enter-frame >> body >> nth=0 >> > * >> nth=1 >> > * >> nth=0 >> > * >> nth=0 >> > * >> nth=0 >> > * >> nth=0 >> > * >> nth=0">
--- Manual Search Result: Found ---
```

which I admit is completely meaningless until you deep dive in the code. 

If you are not interested in the technical details you can leave here and go to [re-broser-use](https://github.com/imamousenotacat/re-browser-use) for some practical use of this.


# TL/DR: Ramblings and technical details

This little program 

```bash
py examples/nopecha_cloudflare.py
```

works as well in *"regular"* patchright. 

When I started this personal for fun project, it didn't, but I think that one of these commits fixed the issue:

```bash
814ccd5 Delete XPath Check to Support XPaths in CSR
b153b7f Fix IFrame Location in Closed Shadow Roots
```

I implemented at the same time my own similar solution and I kept it here.  

The code that still works differently in 'patchright' vs 're-patchright' is this:

```bash
py examples/armas_pal_pueblo.py
```

If you execute it using re-patchright you get the output I've already shown above.

Now uninstall re-patchright (including the browsers, to be thorough) and install patchright instead: 

```bash
re-patchright uninstall --all 
pip uninstall re-patchright -y

pip install patchright
patchright install chromium --with-deps
```

Run the program again:

```bash
py examples\armasPalPueblo.py
```

and now the output is different:

```bash
ARMAS-PAL-PUEBLO 0: Found 120 children ...
ARMAS-PAL-PUEBLO 1: Found 2 children HEAD and BODY the two elements of the Document in the iframe ...
ARMAS-PAL-PUEBLO 2: Found 2 children ...
ARMAS-PAL-PUEBLO 3: Found 2 children ...
ARMAS-PAL-PUEBLO 4: Found 13 children ...
ARMAS-PAL-PUEBLO 5: Found 2 children ...
ARMAS-PAL-PUEBLO 6: Found children_count=[4] SHOULD BE EQUAL TO len(children)=[0] ...
ARMAS-PAL-PUEBLO 7: Found children_count=[0] SHOULD BE EQUAL TO len(children)=[0] ...

--- Starting Manual Recursive Search in Frame (Python API) ---
Checking: <BODY>
 Found 0 children for <BODY>
--- Manual Search Result: Not Found ---
```

Basically, I solved some edge cases in the logic that prevented patchright for being able to recursively traverse a DOM tree by iteratively using a css selector ">*" when there are closed ShadowRoot present.

***This allows me to implement in [re-browser-use](https://github.com/imamousenotacat/re-browser-use) a method that seems to be able to defeat Cloudflare verification while using Browser Use.***

While working on this I think I fixed (for python version, I haven't built the NodeJs library) several issues still open in patchright:

- https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python/issues/61
- https://github.com/Kaliiiiiiiiii-Vinyzu/patchright/issues/81
- https://github.com/Kaliiiiiiiiii-Vinyzu/patchright/issues/94
- https://github.com/Kaliiiiiiiiii-Vinyzu/patchright/issues/98
- https://github.com/Kaliiiiiiiiii-Vinyzu/patchright/issues/100

The last four are related to each other. The solution is not mine I found it [here](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright/issues/81#issuecomment-3009095747)

## Why is this project not a PR or a small collection of them?

Well, to be honest: 

- Playwright code is difficult, at least for me. I work in IT, but I'm not a developer; I never really was, and I probably never will be. What I did was simply follow the logic I was interested in and carefully adapt it to my use case without breaking anything, but without being completely sure that what I was doing was the correct general solution.
- Regarding the fixes for the issues, I'm pretty sure they are correct, but I was in a hurry, I needed the changes, and [Vinyzu](https://github.com/Vinyzu/) seems to be busy lately and not paying much attention to this repository.. 

------

#### Patchright is a patched and undetected version of the Playwright Testing and Automation Framework. </br> It can be used as a drop-in replacement for Playwright.

> [!NOTE]  
> This repository serves the Patchright Driver. To use Patchright, check out the [Python Package](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python) or the [NodeJS Package](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-nodejs).

> [!IMPORTANT]  
> Patchright only patches CHROMIUM based browsers. Firefox and Webkit are not supported.

------

## Copyright and License
© [Vinyzu](https://github.com/Vinyzu/)

Patchright is licensed [Apache 2.0](https://choosealicense.com/licenses/apache-2.0/)

[Some Parts](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright/blob/main/patchright_driver_patch.js#L435-L448) of the Codebase are inspired by [Driverless](https://github.com/kaliiiiiiiiii/Selenium-Driverlesshttps://github.com/kaliiiiiiiiii/Selenium-Driverless).
Thanks to [Nick Webson](https://github.com/rebrowser/rebrowser-patches) for the idea of .patch-File Documentation.

---

## Disclaimer

This repository is provided for **educational purposes only**. \
No warranties are provided regarding accuracy, completeness, or suitability for any purpose. **Use at your own risk**—the authors and maintainers assume **no liability** for **any damages**, **legal issues**, or **warranty breaches** resulting from use, modification, or distribution of this code.\
**Any misuse or legal violations are the sole responsibility of the user**. 

---

## Authors

#### Active Maintainer: [Vinyzu](https://github.com/Vinyzu/) </br> Co-Maintainer: [Kaliiiiiiiiii](https://github.com/kaliiiiiiiiii/)