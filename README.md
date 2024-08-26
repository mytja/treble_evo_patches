# Treble patches for Evolution X
Patches for Evolution X unofficial GSI

## Commonly used for patch applying
1. `git am`
```bash
git am ~/evo/patches/0001-TrebleDroid/platform_.../....patch
```

2. If `git am` fails, attempt a 3-way merge
```bash
git am --3way ~/evo/patches/0001-TrebleDroid/platform_.../....patch
```

3. If 3-way merge fails, generate `.rej` files and apply patches manually
```bash
git am --reject ~/evo/patches/0001-TrebleDroid/platform_.../....patch
```
