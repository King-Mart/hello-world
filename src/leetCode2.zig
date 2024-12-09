const std = @import("std");

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
var node3 = ListNode.init(3, null);
var node2 = ListNode.init(4, &node3);
// Needs to be variable since the pointer is used to iterate through it and it needs to be mutable
var num1 = ListNode.init(2, &node2);

var node6 = ListNode.init(4, null);
var node5 = ListNode.init(6, &node6);
// Needs to be variable since the pointer is used to iterate through it and it needs to be mutable
var num2 = ListNode.init(5, &node5);

var anode3 = ListNode.init(8, null);
var anode2 = ListNode.init(0, &anode3);
var answer = ListNode.init(7, &anode2);

//Does this cause the unwated behaviour of changing the pointer to the next element when computing sums?




fn addTwoNumbers(l1 : *ListNode, l2 : *ListNode) ?*ListNode {
    var carry : i32 = 0;
    var sum : i32 = 0;
    //Make copies of the root nodes to ensure we don't modify them, this answer my question up there
    var iterl1 : ?*ListNode = l1;
    var iterl2 : ?*ListNode = l2;
    //The root of the result node, it will be discarded since the only values that need to be returned are the ones following the root
    var result : ListNode = ListNode.init(0, null);
    //The current node of the result when iterating, it is non nullable since we're always at a digit until the end
    var current : *ListNode = &result;

    while ((iterl1 != null) or (iterl2 != null) or (carry != 0)) {

        //If l1 is null then we reached the end of the first digit
        if (iterl1) |node| {
            sum += node.val;
            iterl1 = node.next;
        }
        //If l2 is null then we reached the end of the second digit
        if (iterl2) |node| {
            sum += node.val;
            iterl2 = node.next;
        }
        //If after iterating through all digit there is still a carry, we need to compute it
        if (carry == 1) {
            sum += 1;
            std.debug.print("The carry right now is : {}\n", .{carry});
            carry = 0;

        }
        carry = if (sum > 9) 1 else 0;
        sum -= 10 * carry;
        const newNode : *ListNode = std.heap.c_allocator.create(ListNode) catch unreachable;
        newNode.* = ListNode.init(sum, null);
        current.next = newNode;
        current = current.next.?;

        sum = 0;
    }
    return result.next;
}

pub fn main() void {
    std.debug.print("I managed to run my own file! (Hello World)", .{});
}

fn freeList(allocator: *const std.mem.Allocator, list: ?*ListNode) void {
    var node = list;
    while (node) |n| {
        const next = n.next;
        allocator.destroy(n);
        node = next;
    }
}

test "TwoNumNoError" {
    const result = addTwoNumbers(&num1, &num2);
    const expected = &answer;
    var enode: ?*ListNode = expected;
    //The defer keyword ensures the memory is freed at the end of this scope (eg. the end of the test, or whenever an interruption occurs)
    defer freeList(&std.heap.c_allocator, result);

    var node = result;
    while (node) |n| {
        std.debug.print("{} -> ", .{n.val});
        if (enode) |eno| {
            std.testing.expectEqual(n.val, eno.val) catch |err| {
                std.debug.print("Test failed: {}\n", .{err});
                return err;
            };
        
        
        node = n.next;
        enode = eno.next;
        }
    }
    std.debug.print("null\n", .{});
}