# Linux-x86_64-nasm-ELF-Brainfuck-Compiler
## このプログラムについて
このプログラムはnasm(NetwideAssembler)によって作られたBrainfuckを直接機械語に変換するプログラムです。
## 実行方法
### コンパイル
```
nasm -f elf64 bf.asm -o bf.o
```
### リンク
```
ld bf.o -o bf
```
### ファイルを指定して実行
```
./bf program.bf
```
## コンパイル例
```
./bf hw.bf
```
これによって生成されるhello,world!の大きさは414byteほど。
最適化してあるためC++や普通のAssemblerより小さい。
だが、巨大なプログラムになると逆にC++のほうが最適化が入ったりして大きさは小さくなる。
