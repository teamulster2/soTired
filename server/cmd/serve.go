package cmd

    import ("github.com/spf13/cobra"
            "context"
            "log"
            "net"
			"fmt"
            "google.golang.org/grpc"
            pb "google.golang.org/grpc/examples/helloworld/helloworld"
    )

// server is used to implement helloworld.GreeterServer.
type server struct {
	pb.UnimplementedGreeterServer
}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", in.GetName())
	fmt.Println("received: " + in.GetName())
	return &pb.HelloReply{Message: "Hello " + in.GetName()}, nil
}

func run(cmd *cobra.Command, args []string) {
	var port = ":50051" // default port
	if len(args) == 1 {
		port = args[0]
    }
	fmt.Println("start server listening on port " + port)
    lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
