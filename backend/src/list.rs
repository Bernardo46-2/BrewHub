use std::fmt::Debug;

type Link<T> = Option<Box<Node<T>>>;

#[derive(Debug)]
struct Node<T> {
    data: T,
    next: Link<T>
}

impl<T> Node<T> {
    fn new(data: T) -> Self {
        Self { data, next: None }
    }
}

#[derive(Debug)]
pub struct List<T> {
    head: Link<T>,
    len: usize
}

impl<T> List<T> {
    pub fn new() -> Self {
        Self { head: None, len: 0 }
    }

    pub fn len(&self) -> usize {
        self.len
    }

    pub fn push(&mut self, data: T) {
        let mut node = Node::new(data);
        node.next = self.head.take();
        self.head = Some(Box::new(node));
        self.len += 1;
    }

    pub fn retain<F> (&mut self, f: F) 
    where
        F: Fn(&T) -> bool
    {
        let mut head = self.head.take();
        let mut new_head = None;
        
        while let Some(mut node) = head.take() {
            head = node.next.take();

            if f(&node.data) {
                node.next = new_head.take();
                new_head = Some(node);
            } else {
                self.len -= 1;
            }
        }

        self.head = new_head;
    }

    pub fn iter(&self) -> Iter<'_, T> {
        Iter { next: self.head.as_ref().map(|node| &**node) }
    }

    pub fn iter_mut(&mut self) -> IterMut<'_, T> {
        IterMut { next: self.head.as_mut().map(|node| &mut **node) }
    }
}

pub struct Iter<'a, T> {
    next: Option<&'a Node<T>>,
}

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;

    fn next(&mut self) -> Option<Self::Item> {
        self.next.map(|node| {
            self.next = node.next.as_ref().map(|next| &**next);
            &node.data
        })
    }
}

pub struct IterMut<'a, T> {
    next: Option<&'a mut Node<T>>,
}

impl<'a, T> Iterator for IterMut<'a, T> {
    type Item = &'a mut T;

    fn next(&mut self) -> Option<Self::Item> {
        self.next.take().map(|node| {
            self.next = node.next.as_mut().map(|next| &mut **next);
            &mut node.data
        })
    }
}
