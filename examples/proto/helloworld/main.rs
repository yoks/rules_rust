extern crate helloworld_lib;
extern crate helloworld_proto;

pub fn main() {
    helloworld_lib::do_something(&helloworld_proto::HelloRequest::new());
}
