//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");

const Node = struct {
    val: i32,
    next: ?*Node,
};

const ListNode = struct{
    val : i32,
    next : ?*ListNode,
    pub fn init(val : i32, next : ?*ListNode) ListNode {
        return ListNode{ 
            .val = val,
            .next = next
        };
    }
};
 

const LinkedList = struct {
    head: ?*Node,   // pointer to the first node in the list
    tail: ?*Node,   // pointer to the last node in the list

};

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});


    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests. I changed the output of this code!\n", .{});

    try bw.flush(); // Don't forget to flush!
    //What is flushing????????
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!

    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
// test "leetCode 2 add two numbers" {
//     // var l1 = std.ArrayList(i32).init(std.testing.allocator);
//     // var l2 = std.ArrayList(i32).init(std.testing.allocator);
//     // l1.append(2);
//     // l1.append(4);
//     // l2.append(5);
//     // l2.append(6);
//     // var sum = addTwoNumbers(l1, l2);
//     // try std.testing.expectEqual(@as(i32, 8), sum);
// }
// test "fuzz example" {
//     const global = struct {
//         fn testOne(input: []const u8) anyerror!void {
//             // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
//             try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
//         }
//     };
//     try std.testing.fuzz(global.testOne, .{});
// }
