export interface Blog {
    id: string;
    body: string;
    data: {
        title: string;
        description: string;
        datetime: string;
        image?: string;
        type: string;
        time_to_read: number;
        level: string;
        category: string;
        tags: string[];
    }
}
