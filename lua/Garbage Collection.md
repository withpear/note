 # Garbage Collection
一个object的生命周期分为四步：
1. 决定创建这个object
2. 为这个object分配所需内存
3. 决定摧毁这个object
4. 释放这个object的内存
lua施行自动内存管理，2，3，4步均为自动，其中第3步为lua gc 处理。
当一个object仍被variable 或 live object所引用的时候，那么它可以被认为是一个 live object，一定不会被lua所摧毁；否则这个object就会在某个时间或最终被lua所摧毁。