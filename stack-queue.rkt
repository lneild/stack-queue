#lang dssl2

let eight_principles = ["Know your rights.",
    "Acknowledge your sources.",
    "Protect your work.",
    "Avoid suspicion.",
    "Do your own work.",
    "Never falsify a record or permit another person to do so.",
    "Never fabricate data, citations, or experimental results.",
    "Always tell the truth when discussing your work with your instructor."]

# HW2: Stacks and Queues

import ring_buffer

interface STACK[T]:
    def push(self, element: T) -> NoneC
    def pop(self) -> T
    def empty?(self) -> bool?

# Defined in the `ring_buffer` library; copied here for reference:
# interface QUEUE[T]:
#     def enqueue(self, element: T) -> NoneC
#     def dequeue(self) -> T
#     def empty?(self) -> bool?

# Linked-list node struct (implementation detail):
struct _cons:
    let data
    let next: OrC(_cons?, NoneC)

###
### ListStack
###

class ListStack (STACK):
    # Any fields you may need can go here.
    let head
    
    # Constructs an empty ListStack.
    def __init__ (self):
        self.head = None

    # Other methods you may need can go here.
        
    # getters:
    def get_head_data(self): return self.head.data
    def get_head_next(self): return self.head.next
        
    # push(Stack, Elem) : None
    # adds elem to the top of the stack
    def push(self, e):
        # if first node
        if self.empty?(): 
            # can add any type
            self.head = _cons(e, None)
        else: 
            # need to check that types match: 
            let c = self.head
            self.head = _cons(e, c) # data = param, next points to a _con
            
    # pop(Stack) : elem
    # removes elem from the top of the stack and returns it 
    def pop (self):
        # empty list?
        if self.empty?(): 
            error('You cannot pop an elem from an empty list')
        else:
            let d = self.get_head_data()
            let n = self.get_head_next()
            self.head = n
            return d
        
    # empty?(Stack) : bool
    # checks if linked list is empty 
    def empty?(self):
        if self.head == None: return True
        else: return False

test "stack push check":
    let s = ListStack()
    s.push(4)
    assert s.get_head_data() == 4
    assert s.get_head_next() == None
    s.push(5)
    assert s.get_head_data() == 5
    assert s.get_head_next() == _cons(4,None)
    assert s.get_head_next().data == 4
    s.push(7)
    assert s.get_head_data() == 7
    assert s.get_head_next() == _cons(5,_cons(4,None))
    assert s.get_head_next().data == 5
    
test "stack pop check":
    let s = ListStack()
    assert_error s.pop()
    
    s.push(4)
    s.push(5)
    s.push(6)
    
    assert s.get_head_data() == 6
    assert s.get_head_next() == _cons(5,_cons(4,None))
    assert s.get_head_next().data == 5
    assert s.pop() == 6
    assert s.get_head_data() == 5
    assert s.get_head_next() == _cons(4,None)
    assert s.pop() == 5
    assert s.get_head_data() == 4
    assert s.get_head_next() == None
    assert s.pop() == 4
    assert_error s.pop()

                
test "stack empty check":
    let s = ListStack()
    assert s.empty?() == True
    s.push("hey")
    assert s.empty?() == False
    
    
test "woefully insufficient":
    let s = ListStack()
    s.push(2)
    assert s.pop() == 2

###
### ListQueue
###
   

class ListQueue (QUEUE):

    # Any fields you may need can go here.
    let head
    let tail

    # Constructs an empty ListQueue
    def __init__ (self):
        self.head = None
        self.tail = None

    # Other methods you may need can go here.
        
    # getters:
    def get_head_data(self): return self.head.data
    def get_head_next(self): return self.head.next
    
    def get_tail_data(self): return self.tail.data
    def get_tail_next(self): return self.tail.next
        
    # def enqueue(self, element: T) -> NoneC
    # add elem to end of q
    def enqueue(self, e):
        if self.empty?():
            self.head = _cons(e, None)
            self.tail = self.head
        else:
            self.tail.next = _cons(e,None)
            self.tail = self.tail.next
            
    def dequeue(self):
        if self.empty?(): 
            error('Cannot dequeue on empty queue') 
            return None
        else:
            let c = self.head
            self.head = self.head.next
            return c.data
        
    # empty?(Queue) : bool
    # checks if linked list is empty
    def empty?(self):
        if self.head == None: return True
        else: return False
            
test "q enqueue check":
    let q = ListQueue()
    q.enqueue(6)
    assert q.get_head_data() == 6
    assert q.get_head_next() == None
    assert q.get_tail_data() == 6
    assert q.get_tail_next() == None
    q.enqueue(7)
    assert q.get_head_data() == 6
    assert q.get_head_next() == _cons(7, None)
    assert q.get_head_next().data == 7
    assert q.get_tail_data() == 7
    assert q.get_tail_next() == None
    
test "q dequeue check":
    let q = ListQueue()
    assert q.empty?() == True
    assert_error q.dequeue()
    q.enqueue(1)
    q.enqueue(2)
    q.enqueue(3)
    q.enqueue(4)
    q.enqueue(5)
    assert q.dequeue() == 1
    assert q.dequeue() == 2
    assert q.empty?() == False
    assert q.dequeue() == 3
    assert q.dequeue() == 4
    assert q.dequeue() == 5
    assert_error q.dequeue()
    
test "q empty check":
    let q = ListQueue()
    assert q.empty?() == True
    q.enqueue(6)
    assert q.empty?() == False
    q.enqueue(7)
    q.enqueue(8)
    assert q.empty?() == False
    
test "woefully insufficient, part 2":
    let q = ListQueue()
    q.enqueue(2)
    assert q.dequeue() == 2

###
### Playlists
###

struct song:
    let title: str?
    let artist: str?
    let album: str?

# Enqueue five songs of your choice to the given queue, then return the first
# song that should play.
def fill_playlist (q: QUEUE!):
    if not q.empty?(): error("You did not pass an empty queue")
    q.enqueue(song("Dark Fantasy", "Kayne", "My Beautiful Dark Twisted Fantasy"))
    q.enqueue(song("8teen", "Khalid", "American Teen"))
    q.enqueue(song("UCLA", "RL Grime", "NOVA"))
    q.enqueue(song("Stole the Show", "Kygo", "Cloud Nine"))
    q.enqueue(song("A-O-K", "Tai Verdes", "TV"))
    q.dequeue()
    
test "ListQueue playlist":
    let q = ListQueue()
    assert q.empty?() == True
    assert fill_playlist(q) == song("Dark Fantasy", "Kayne", "My Beautiful Dark Twisted Fantasy")
    assert q.empty?() == False
    assert_error fill_playlist(q)
    assert q.dequeue() == song("8teen", "Khalid", "American Teen")
    assert q.dequeue() == song("UCLA", "RL Grime", "NOVA")
    assert q.dequeue() == song("Stole the Show", "Kygo", "Cloud Nine")
    assert q.dequeue() == song("A-O-K", "Tai Verdes", "TV")
    assert_error q.dequeue()
    
# To construct a RingBuffer: RingBuffer(capacity)
test "RingBuffer playlist":
    let rb = RingBuffer(5)
    assert rb.empty?() == True
    assert fill_playlist(rb) == song("Dark Fantasy", "Kayne", "My Beautiful Dark Twisted Fantasy")
    assert rb.empty?() == False
    assert_error fill_playlist(rb)
    assert rb.dequeue() == song("8teen", "Khalid", "American Teen")
    assert rb.dequeue() == song("UCLA", "RL Grime", "NOVA")
    assert rb.dequeue() == song("Stole the Show", "Kygo", "Cloud Nine")
    assert rb.dequeue() == song("A-O-K", "Tai Verdes", "TV")
    assert_error rb.dequeue()